import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../common/data/isar_provider.dart';
import '../domain/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> importProfile(UserProfile profile);
}

class IsarUserProfileRepository implements UserProfileRepository {
  final Isar isar;

  IsarUserProfileRepository(this.isar);

  @override
  Future<UserProfile> getUserProfile() async {
    final profile = await isar.userProfiles.get(0);
    if (profile == null) {
      // Create default profile if not exists
      final newProfile = UserProfile(name: 'User');
      await isar.writeTxn(() async {
        await isar.userProfiles.put(newProfile);
      });
      return newProfile;
    }
    return profile;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await isar.writeTxn(() async {
      profile.id = 0; // Ensure ID is always 0
      await isar.userProfiles.put(profile);
    });
  }

  @override
  Future<void> importProfile(UserProfile profile) async {
    await isar.writeTxn(() async {
      profile.id = 0;
      await isar.userProfiles.put(profile);
    });
  }
}

final userProfileRepositoryProvider = FutureProvider<UserProfileRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarUserProfileRepository(isar);
});

final userProfileProvider = StreamProvider<UserProfile>((ref) async* {
  final repo = await ref.watch(userProfileRepositoryProvider.future);
  final isar = (repo as IsarUserProfileRepository).isar;

  // Ensure initial value exists
  final initial = await repo.getUserProfile();
  yield initial;
  
  // Watch for changes
  await for (final _ in isar.userProfiles.watchObject(0)) {
    final profile = await isar.userProfiles.get(0);
    if (profile != null) yield profile;
  }
});
