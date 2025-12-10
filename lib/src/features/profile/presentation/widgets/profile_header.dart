import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../data/user_profile_repository.dart';
import '../../domain/user_profile.dart';

class ProfileHeader extends ConsumerWidget {
  final UserProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showEditProfileDialog(context, ref, profile),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.accentBlue,
                backgroundImage: profile.profileImagePath != null
                    ? FileImage(File(profile.profileImagePath!))
                    : null,
                child: profile.profileImagePath == null
                    ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Name & Email
        Text(profile.name, style: AppTextStyles.h2),
        if (profile.email != null)
          Text(profile.email!, style: AppTextStyles.bodyMedium),


      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfile profile) {
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final updatedProfile = UserProfile(
                    name: profile.name,
                    email: profile.email,
                    currencyCode: profile.currencyCode,
                    profileImagePath: image.path,
                  )..id = profile.id;

                  await ref.read(userProfileRepositoryProvider.future).then((repo) {
                    repo.updateUserProfile(updatedProfile);
                  });
                  if (context.mounted) Navigator.pop(context); // Close dialog to refresh or show success
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.accentBlue,
                backgroundImage: profile.profileImagePath != null
                    ? FileImage(File(profile.profileImagePath!))
                    : null,
                child: profile.profileImagePath == null
                    ? const Icon(Icons.camera_alt, size: 30, color: AppColors.primary)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email (Optional)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedProfile = UserProfile(
                name: nameController.text,
                email: emailController.text.isEmpty ? null : emailController.text,
                currencyCode: profile.currencyCode,
                profileImagePath: profile.profileImagePath,
                )..id = profile.id;

              await ref.read(userProfileRepositoryProvider.future).then((repo) {
                repo.updateUserProfile(updatedProfile);
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
