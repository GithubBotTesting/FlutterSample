class RoommateRequest {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String title;
  final String description;
  final String roomType;
  final String preferredCity;
  final String preferredMajor;
  final String smokingPreference;
  final String sleepSchedule;
  final String studyHabits;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoommateRequest({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.title,
    required this.description,
    required this.roomType,
    this.preferredCity = 'Any',
    this.preferredMajor = 'Any',
    this.smokingPreference = 'No Preference',
    this.sleepSchedule = 'Flexible',
    this.studyHabits = 'Moderate',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'title': title,
    'description': description,
    'roomType': roomType,
    'preferredCity': preferredCity,
    'preferredMajor': preferredMajor,
    'smokingPreference': smokingPreference,
    'sleepSchedule': sleepSchedule,
    'studyHabits': studyHabits,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory RoommateRequest.fromJson(Map<String, dynamic> json) => RoommateRequest(
    id: json['id'] ?? '',
    userId: json['userId'] ?? '',
    userName: json['userName'] ?? '',
    userAvatar: json['userAvatar'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    roomType: json['roomType'] ?? '',
    preferredCity: json['preferredCity'] ?? 'Any',
    preferredMajor: json['preferredMajor'] ?? 'Any',
    smokingPreference: json['smokingPreference'] ?? 'No Preference',
    sleepSchedule: json['sleepSchedule'] ?? 'Flexible',
    studyHabits: json['studyHabits'] ?? 'Moderate',
    isActive: json['isActive'] ?? true,
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
  );

  RoommateRequest copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? title,
    String? description,
    String? roomType,
    String? preferredCity,
    String? preferredMajor,
    String? smokingPreference,
    String? sleepSchedule,
    String? studyHabits,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoommateRequest(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userAvatar: userAvatar ?? this.userAvatar,
    title: title ?? this.title,
    description: description ?? this.description,
    roomType: roomType ?? this.roomType,
    preferredCity: preferredCity ?? this.preferredCity,
    preferredMajor: preferredMajor ?? this.preferredMajor,
    smokingPreference: smokingPreference ?? this.smokingPreference,
    sleepSchedule: sleepSchedule ?? this.sleepSchedule,
    studyHabits: studyHabits ?? this.studyHabits,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
