import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../data/user_profile_repository.dart';
import '../../domain/user_profile.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class ProfileHeader extends ConsumerWidget {
  final UserProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showEditProfileDialog(context, ref, profile),
      child: Column(
        children: [
          // Avatar centered
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: profile.profileImagePath != null
                      ? FileImage(File(profile.profileImagePath!))
                      : null,
                  child: profile.profileImagePath == null
                      ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Name & Email centered
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (profile.email != null)
            Text(
              profile.email!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfile profile) {
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    // Temporary holder for image path if user changes it but hasn't saved yet
    String? tempImagePath = profile.profileImagePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.editProfileTitle,
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 24),
                    
                    // Image Picker
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            tempImagePath = image.path;
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.accentBlue.withOpacity(0.1),
                            backgroundImage: tempImagePath != null
                                ? FileImage(File(tempImagePath!))
                                : null,
                            child: tempImagePath == null
                                ? const Icon(Icons.person, size: 50, color: AppColors.primary)
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.uploadPhoto,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Name Field
                    TextField(
                      controller: nameController,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.nameLabel,
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Email Field
                    TextField(
                      controller: emailController,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.emailLabel,
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                         focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final updatedProfile = UserProfile(
                                name: nameController.text,
                                email: emailController.text.isEmpty ? null : emailController.text,
                                currencyCode: profile.currencyCode,
                                profileImagePath: tempImagePath, // Use the temp image path
                              )..id = profile.id;

                              await ref.read(userProfileRepositoryProvider.future).then((repo) {
                                repo.updateUserProfile(updatedProfile);
                              });
                              if (context.mounted) Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.saveChanges,
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
