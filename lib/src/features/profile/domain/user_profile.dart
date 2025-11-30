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
}
