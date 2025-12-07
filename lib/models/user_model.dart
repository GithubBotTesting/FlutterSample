class AppUser {
  final String id;
  final String name;
  final String email;
  final String major;
  final String city;
  final int year;
  final String bio;
  final String avatarUrl;
  final String smokingPreference;
  final String sleepSchedule;
  final String studyHabits;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.city,
    required this.year,
    this.bio = '',
    this.avatarUrl = '',
    this.smokingPreference = 'No Preference',
    this.sleepSchedule = 'Flexible',
    this.studyHabits = 'Moderate',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'major': major,
    'city': city,
    'year': year,
    'bio': bio,
    'avatarUrl': avatarUrl,
    'smokingPreference': smokingPreference,
    'sleepSchedule': sleepSchedule,
    'studyHabits': studyHabits,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    major: json['major'] ?? '',
    city: json['city'] ?? '',
    year: json['year'] ?? 1,
    bio: json['bio'] ?? '',
    avatarUrl: json['avatarUrl'] ?? '',
    smokingPreference: json['smokingPreference'] ?? 'No Preference',
    sleepSchedule: json['sleepSchedule'] ?? 'Flexible',
    studyHabits: json['studyHabits'] ?? 'Moderate',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
  );

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? major,
    String? city,
    int? year,
    String? bio,
    String? avatarUrl,
    String? smokingPreference,
    String? sleepSchedule,
    String? studyHabits,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppUser(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    major: major ?? this.major,
    city: city ?? this.city,
    year: year ?? this.year,
    bio: bio ?? this.bio,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    smokingPreference: smokingPreference ?? this.smokingPreference,
    sleepSchedule: sleepSchedule ?? this.sleepSchedule,
    studyHabits: studyHabits ?? this.studyHabits,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
