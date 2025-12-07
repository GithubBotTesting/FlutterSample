import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:dormlink/models/user_model.dart';

class UserService extends ChangeNotifier {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';
  final Uuid _uuid = const Uuid();
  
  List<AppUser> _users = [];
  AppUser? _currentUser;
  bool _isLoading = false;

  List<AppUser> get users => _users;
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    final currentUserId = prefs.getString(_currentUserKey);
    
    if (usersJson == null) {
      await _initSampleData(prefs);
    } else {
      try {
        final List<dynamic> decoded = jsonDecode(usersJson);
        _users = decoded.map((e) => AppUser.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading users: $e');
        await _initSampleData(prefs);
      }
    }
    
    if (currentUserId != null) {
      _currentUser = _users.firstWhere(
        (u) => u.id == currentUserId,
        orElse: () => _users.first,
      );
    } else if (_users.isNotEmpty) {
      _currentUser = _users.first;
      await prefs.setString(_currentUserKey, _currentUser!.id);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    _users = [
      AppUser(
        id: _uuid.v4(),
        name: 'Ahmed Al-Rashid',
        email: 'ahmed.rashid@kfupm.edu.sa',
        major: 'Computer Science',
        city: 'Riyadh',
        year: 3,
        bio: 'CS student passionate about AI and machine learning. Looking for a quiet and studious roommate.',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Early Bird',
        studyHabits: 'Heavy Studier',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      AppUser(
        id: _uuid.v4(),
        name: 'Mohammed Al-Fahad',
        email: 'mohammed.fahad@kfupm.edu.sa',
        major: 'Mechanical Engineering',
        city: 'Dammam',
        year: 2,
        bio: 'Engineering enthusiast who loves sports. Looking for an active roommate.',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Night Owl',
        studyHabits: 'Moderate',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
      ),
      AppUser(
        id: _uuid.v4(),
        name: 'Khalid Al-Otaibi',
        email: 'khalid.otaibi@kfupm.edu.sa',
        major: 'Electrical Engineering',
        city: 'Jeddah',
        year: 4,
        bio: 'Senior EE student. Prefer a calm and organized living space.',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Flexible',
        studyHabits: 'Heavy Studier',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      AppUser(
        id: _uuid.v4(),
        name: 'Omar Al-Saud',
        email: 'omar.saud@kfupm.edu.sa',
        major: 'Information Systems',
        city: 'Khobar',
        year: 1,
        bio: 'First-year student eager to make new friends and explore campus life.',
        smokingPreference: 'No Preference',
        sleepSchedule: 'Flexible',
        studyHabits: 'Light Studier',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      AppUser(
        id: _uuid.v4(),
        name: 'Faisal Al-Zahrani',
        email: 'faisal.zahrani@kfupm.edu.sa',
        major: 'Chemical Engineering',
        city: 'Makkah',
        year: 3,
        bio: 'ChemE student interested in research. Clean and organized.',
        smokingPreference: 'Non-Smoker',
        sleepSchedule: 'Early Bird',
        studyHabits: 'Moderate',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
    ];
    await _saveUsers(prefs);
  }

  Future<void> _saveUsers(SharedPreferences prefs) async {
    final encoded = jsonEncode(_users.map((e) => e.toJson()).toList());
    await prefs.setString(_usersKey, encoded);
  }

  Future<void> setCurrentUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = _users.firstWhere((u) => u.id == userId);
    await prefs.setString(_currentUserKey, userId);
    notifyListeners();
  }

  Future<void> updateUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user.copyWith(updatedAt: DateTime.now());
      if (_currentUser?.id == user.id) {
        _currentUser = _users[index];
      }
      await _saveUsers(prefs);
      notifyListeners();
    }
  }

  AppUser? getUserById(String id) => _users.firstWhere((u) => u.id == id, orElse: () => _users.first);
}
