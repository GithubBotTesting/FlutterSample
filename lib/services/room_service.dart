import 'package:dormlink/models/room_type_model.dart';

class RoomService {
  static List<RoomType> getRoomTypes() => [
    RoomType(
      id: '1',
      name: 'Single Room',
      description: 'Private room for one student. Ideal for those who prefer solitude and quiet study time.',
      capacity: 1,
      amenities: ['Private Bathroom', 'Study Desk', 'Wardrobe', 'AC', 'Wi-Fi'],
    ),
    RoomType(
      id: '2',
      name: 'Double Room',
      description: 'Shared room for two students. Perfect for making a new friend while splitting costs.',
      capacity: 2,
      amenities: ['Shared Bathroom', '2 Study Desks', '2 Wardrobes', 'AC', 'Wi-Fi'],
    ),
    RoomType(
      id: '3',
      name: 'Triple Room',
      description: 'Shared room for three students. Great for a social atmosphere and the most economical choice.',
      capacity: 3,
      amenities: ['Shared Bathroom', '3 Study Desks', '3 Wardrobes', 'AC', 'Wi-Fi'],
    ),
    RoomType(
      id: '4',
      name: 'Suite',
      description: 'Premium living space with a common area. Best for students who want extra comfort and space.',
      capacity: 2,
      amenities: ['Private Bathroom', 'Living Area', 'Mini Kitchen', '2 Bedrooms', 'AC', 'Wi-Fi'],
    ),
  ];

  static List<String> getCities() => [
    'Any',
    'Riyadh',
    'Jeddah',
    'Makkah',
    'Madinah',
    'Dammam',
    'Khobar',
    'Dhahran',
    'Tabuk',
    'Taif',
    'Abha',
  ];

  static List<String> getMajors() => [
    'Any',
    'Computer Science',
    'Computer Engineering',
    'Software Engineering',
    'Information Systems',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Chemical Engineering',
    'Civil Engineering',
    'Petroleum Engineering',
    'Industrial Engineering',
    'Aerospace Engineering',
    'Architecture',
    'Physics',
    'Mathematics',
    'Chemistry',
    'Finance',
    'Accounting',
    'Management',
  ];

  static List<String> getSmokingPreferences() => [
    'No Preference',
    'Non-Smoker',
    'Smoker',
  ];

  static List<String> getSleepSchedules() => [
    'Flexible',
    'Early Bird',
    'Night Owl',
  ];

  static List<String> getStudyHabits() => [
    'Light Studier',
    'Moderate',
    'Heavy Studier',
  ];

  static List<String> getRoomTypeNames() => [
    'Any',
    'Single Room',
    'Double Room',
    'Triple Room',
    'Suite',
  ];
}
