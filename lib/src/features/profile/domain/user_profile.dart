import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = 0; // Singleton ID

  String name;
  String? profileImagePath;
  String? email;
  String currencyCode;

  UserProfile({
    this.name = 'User',
    this.profileImagePath,
    this.email,
    this.currencyCode = 'IDR',
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileImagePath': profileImagePath,
      'email': email,
      'currencyCode': currencyCode,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'User',
      profileImagePath: json['profileImagePath'] as String?,
      email: json['email'] as String?,
      currencyCode: json['currencyCode'] as String? ?? 'IDR',
    )..id = 0;
  }
}
