import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:dormlink/models/chat_message_model.dart';

class ChatService extends ChangeNotifier {
  static const String _conversationsKey = 'chat_conversations';
  static const String _messagesKey = 'chat_messages';
  final Uuid _uuid = const Uuid();
  
  List<ChatConversation> _conversations = [];
  Map<String, List<ChatMessage>> _messagesByConversation = {};
  bool _isLoading = false;

  List<ChatConversation> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = prefs.getString(_conversationsKey);
    final messagesJson = prefs.getString(_messagesKey);
    
    if (conversationsJson == null) {
      await _initSampleData(prefs);
    } else {
      try {
        final List<dynamic> decodedConvs = jsonDecode(conversationsJson);
        _conversations = decodedConvs.map((e) => ChatConversation.fromJson(e)).toList();
        
        if (messagesJson != null) {
          final Map<String, dynamic> decodedMsgs = jsonDecode(messagesJson);
          _messagesByConversation = decodedMsgs.map((key, value) => 
            MapEntry(key, (value as List).map((e) => ChatMessage.fromJson(e)).toList())
          );
        }
      } catch (e) {
        debugPrint('Error loading chat data: $e');
        await _initSampleData(prefs);
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    final conv1Id = _uuid.v4();
    final conv2Id = _uuid.v4();
    
    _conversations = [
      ChatConversation(
        id: conv1Id,
        participantIds: ['user1', 'user2'],
        participantNames: ['Ahmed Al-Rashid', 'Mohammed Al-Fahad'],
        lastMessage: 'Sounds good! When can we meet to discuss?',
        lastMessageAt: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      ChatConversation(
        id: conv2Id,
        participantIds: ['user1', 'user3'],
        participantNames: ['Ahmed Al-Rashid', 'Khalid Al-Otaibi'],
        lastMessage: 'I\'ll check the portal and get back to you.',
        lastMessageAt: now.subtract(const Duration(hours: 5)),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
    
    _messagesByConversation = {
      conv1Id: [
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv1Id,
          senderId: 'user1',
          content: 'Hey! I saw your roommate request. I think we might be a good match!',
          sentAt: now.subtract(const Duration(hours: 4)),
        ),
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv1Id,
          senderId: 'user2',
          content: 'Hi Ahmed! Yes, I noticed we have similar study habits. Are you still looking?',
          sentAt: now.subtract(const Duration(hours: 3, minutes: 30)),
        ),
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv1Id,
          senderId: 'user1',
          content: 'Yes, I am! I prefer a quiet environment and usually study in the evenings.',
          sentAt: now.subtract(const Duration(hours: 3)),
        ),
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv1Id,
          senderId: 'user2',
          content: 'Sounds good! When can we meet to discuss?',
          sentAt: now.subtract(const Duration(hours: 2)),
        ),
      ],
      conv2Id: [
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv2Id,
          senderId: 'user3',
          content: 'Hello! Are you interested in being roommates for next semester?',
          sentAt: now.subtract(const Duration(hours: 8)),
        ),
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv2Id,
          senderId: 'user1',
          content: 'Hi Khalid! Yes, I\'m very interested. What room type are you looking at?',
          sentAt: now.subtract(const Duration(hours: 7)),
        ),
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv2Id,
          senderId: 'user3',
          content: 'I was thinking a double room. Have you submitted anything on the portal yet?',
          sentAt: now.subtract(const Duration(hours: 6)),
        ),
        ChatMessage(
          id: _uuid.v4(),
          conversationId: conv2Id,
          senderId: 'user1',
          content: 'I\'ll check the portal and get back to you.',
          sentAt: now.subtract(const Duration(hours: 5)),
        ),
      ],
    };
    
    await _saveData(prefs);
  }

  Future<void> _saveData(SharedPreferences prefs) async {
    final conversationsEncoded = jsonEncode(_conversations.map((e) => e.toJson()).toList());
    await prefs.setString(_conversationsKey, conversationsEncoded);
    
    final messagesEncoded = jsonEncode(_messagesByConversation.map(
      (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())
    ));
    await prefs.setString(_messagesKey, messagesEncoded);
  }

  List<ChatMessage> getMessages(String conversationId) => _messagesByConversation[conversationId] ?? [];

  Future<ChatConversation> getOrCreateConversation(
    String currentUserId, 
    String currentUserName,
    String otherUserId, 
    String otherUserName,
  ) async {
    final existing = _conversations.where((c) => 
      c.participantIds.contains(currentUserId) && c.participantIds.contains(otherUserId)
    ).toList();
    
    if (existing.isNotEmpty) return existing.first;
    
    final prefs = await SharedPreferences.getInstance();
    final newConversation = ChatConversation(
      id: _uuid.v4(),
      participantIds: [currentUserId, otherUserId],
      participantNames: [currentUserName, otherUserName],
      lastMessageAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    
    _conversations.insert(0, newConversation);
    _messagesByConversation[newConversation.id] = [];
    await _saveData(prefs);
    notifyListeners();
    
    return newConversation;
  }

  Future<void> sendMessage(String conversationId, String senderId, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final message = ChatMessage(
      id: _uuid.v4(),
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      sentAt: DateTime.now(),
    );
    
    _messagesByConversation[conversationId] ??= [];
    _messagesByConversation[conversationId]!.add(message);
    
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: content,
        lastMessageAt: DateTime.now(),
      );
      final conv = _conversations.removeAt(convIndex);
      _conversations.insert(0, conv);
    }
    
    await _saveData(prefs);
    notifyListeners();
  }
}
