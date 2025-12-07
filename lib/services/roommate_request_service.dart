import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:dormlink/models/roommate_request_model.dart';

class RoommateRequestService extends ChangeNotifier {
  static const String _requestsKey = 'roommate_requests';
  final Uuid _uuid = const Uuid();
  
  List<RoommateRequest> _requests = [];
  bool _isLoading = false;

  List<RoommateRequest> get requests => _requests;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final requestsJson = prefs.getString(_requestsKey);
    
    if (requestsJson == null) {
      await _initSampleData(prefs);
    } else {
      try {
        final List<dynamic> decoded = jsonDecode(requestsJson);
        _requests = decoded.map((e) => RoommateRequest.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading requests: $e');
        await _initSampleData(prefs);
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    _requests = [
      RoommateRequest(
        id: _uuid.v4(),
        userId: 'user1',
        userName: 'Ahmed Al-Rashid',
        title: 'Looking for a quiet CS roommate',
        description: 'I am a 3rd year CS student looking for a roommate who values quiet study time and keeps the room organized. Prefer someone from a similar major.',
        roomType: 'Double Room',
        preferredCity: 'Riyadh',
        preferredMajor: 'Computer Science',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Early Bird',
        studyHabits: 'Heavy Studier',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      RoommateRequest(
        id: _uuid.v4(),
        userId: 'user2',
        userName: 'Mohammed Al-Fahad',
        title: 'Sports enthusiast seeking active roommate',
        description: 'Engineering student who plays football and basketball. Looking for someone who enjoys staying active and doesn\'t mind late-night gaming sessions.',
        roomType: 'Double Room',
        preferredCity: 'Dammam',
        preferredMajor: 'Any',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Night Owl',
        studyHabits: 'Moderate',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      RoommateRequest(
        id: _uuid.v4(),
        userId: 'user3',
        userName: 'Khalid Al-Otaibi',
        title: 'Senior EE student - organized & focused',
        description: 'Final year electrical engineering student preparing for graduation. Need a roommate who respects quiet hours and keeps common spaces clean.',
        roomType: 'Single Room',
        preferredCity: 'Any',
        preferredMajor: 'Engineering',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Flexible',
        studyHabits: 'Heavy Studier',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      RoommateRequest(
        id: _uuid.v4(),
        userId: 'user4',
        userName: 'Omar Al-Saud',
        title: 'Freshman looking for friends!',
        description: 'New to KFUPM and excited to meet people! I\'m easygoing and open to any roommate. Let\'s make our first year memorable together.',
        roomType: 'Triple Room',
        preferredCity: 'Any',
        preferredMajor: 'Any',
        smokingPreference: 'No Preference',
        sleepSchedule: 'Flexible',
        studyHabits: 'Light Studier',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      RoommateRequest(
        id: _uuid.v4(),
        userId: 'user5',
        userName: 'Faisal Al-Zahrani',
        title: 'Research-focused ChemE student',
        description: 'Spending most of my time in the lab or library. Looking for a roommate with similar dedication to academics. Early riser preferred.',
        roomType: 'Double Room',
        preferredCity: 'Makkah',
        preferredMajor: 'Chemical Engineering',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Early Bird',
        studyHabits: 'Heavy Studier',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
    await _saveRequests(prefs);
  }

  Future<void> _saveRequests(SharedPreferences prefs) async {
    final encoded = jsonEncode(_requests.map((e) => e.toJson()).toList());
    await prefs.setString(_requestsKey, encoded);
  }

  Future<void> addRequest(RoommateRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final newRequest = RoommateRequest(
      id: _uuid.v4(),
      userId: request.userId,
      userName: request.userName,
      userAvatar: request.userAvatar,
      title: request.title,
      description: request.description,
      roomType: request.roomType,
      preferredCity: request.preferredCity,
      preferredMajor: request.preferredMajor,
      smokingPreference: request.smokingPreference,
      sleepSchedule: request.sleepSchedule,
      studyHabits: request.studyHabits,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _requests.insert(0, newRequest);
    await _saveRequests(prefs);
    notifyListeners();
  }

  Future<void> updateRequest(RoommateRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final index = _requests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      _requests[index] = request.copyWith(updatedAt: DateTime.now());
      await _saveRequests(prefs);
      notifyListeners();
    }
  }

  Future<void> deleteRequest(String requestId) async {
    final prefs = await SharedPreferences.getInstance();
    _requests.removeWhere((r) => r.id == requestId);
    await _saveRequests(prefs);
    notifyListeners();
  }

  List<RoommateRequest> filterRequests({
    String? city,
    String? major,
    String? smokingPreference,
    String? sleepSchedule,
    String? studyHabits,
    String? roomType,
  }) {
    return _requests.where((r) {
      if (city != null && city != 'Any' && r.preferredCity != 'Any' && r.preferredCity != city) return false;
      if (major != null && major != 'Any' && r.preferredMajor != 'Any' && r.preferredMajor != major) return false;
      if (smokingPreference != null && smokingPreference != 'No Preference' && r.smokingPreference != 'No Preference' && r.smokingPreference != smokingPreference) return false;
      if (sleepSchedule != null && sleepSchedule != 'Flexible' && r.sleepSchedule != 'Flexible' && r.sleepSchedule != sleepSchedule) return false;
      if (studyHabits != null && studyHabits != 'Moderate' && r.studyHabits != studyHabits) return false;
      if (roomType != null && roomType != 'Any' && r.roomType != roomType) return false;
      return r.isActive;
    }).toList();
  }
}
