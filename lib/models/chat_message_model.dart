class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'content': content,
    'sentAt': sentAt.toIso8601String(),
    'isRead': isRead,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] ?? '',
    conversationId: json['conversationId'] ?? '',
    senderId: json['senderId'] ?? '',
    content: json['content'] ?? '',
    sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    isRead: json['isRead'] ?? false,
  );

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    DateTime? sentAt,
    bool? isRead,
  }) => ChatMessage(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    sentAt: sentAt ?? this.sentAt,
    isRead: isRead ?? this.isRead,
  );
}

class ChatConversation {
  final String id;
  final List<String> participantIds;
  final List<String> participantNames;
  final List<String> participantAvatars;
  final String lastMessage;
  final DateTime lastMessageAt;
  final DateTime createdAt;

  ChatConversation({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    this.participantAvatars = const [],
    this.lastMessage = '',
    required this.lastMessageAt,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'participantIds': participantIds,
    'participantNames': participantNames,
    'participantAvatars': participantAvatars,
    'lastMessage': lastMessage,
    'lastMessageAt': lastMessageAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory ChatConversation.fromJson(Map<String, dynamic> json) => ChatConversation(
    id: json['id'] ?? '',
    participantIds: List<String>.from(json['participantIds'] ?? []),
    participantNames: List<String>.from(json['participantNames'] ?? []),
    participantAvatars: List<String>.from(json['participantAvatars'] ?? []),
    lastMessage: json['lastMessage'] ?? '',
    lastMessageAt: DateTime.tryParse(json['lastMessageAt'] ?? '') ?? DateTime.now(),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );

  ChatConversation copyWith({
    String? id,
    List<String>? participantIds,
    List<String>? participantNames,
    List<String>? participantAvatars,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) => ChatConversation(
    id: id ?? this.id,
    participantIds: participantIds ?? this.participantIds,
    participantNames: participantNames ?? this.participantNames,
    participantAvatars: participantAvatars ?? this.participantAvatars,
    lastMessage: lastMessage ?? this.lastMessage,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    createdAt: createdAt ?? this.createdAt,
  );
}
