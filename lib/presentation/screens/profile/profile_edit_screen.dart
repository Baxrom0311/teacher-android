import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final ProfileResponse currentProfile;

  const ProfileEditScreen({super.key, required this.currentProfile});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _universityController;
  late TextEditingController _specializationController;
  late TextEditingController _addressController;
  late TextEditingController _achievementsController;
  late TextEditingController _categoryController;
  String? _photoPath;
  String? _diplomaPath;
  String? _passportCopyPath;
  String? _graduationDate;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final profile = widget.currentProfile.profile;
    _universityController = TextEditingController(text: profile?.university);
    _specializationController = TextEditingController(
      text: profile?.specialization,
    );
    _addressController = TextEditingController(text: profile?.address);
    _achievementsController = TextEditingController(
      text: profile?.achievements,
    );
    _categoryController = TextEditingController(text: profile?.category);
    _graduationDate = profile?.graduationDate;
    _gender = profile?.gender;
  }

  @override
  void dispose() {
    _universityController.dispose();
    _specializationController.dispose();
    _addressController.dispose();
    _achievementsController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _photoPath = result.files.single.path;
      });
    }
  }

  Future<void> _pickDocument({
    required void Function(String path) onPicked,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      onPicked(result.files.single.path!);
    }
  }

  Future<void> _pickGraduationDate() async {
    final l10n = context.l10n;
    final initialDate = _graduationDate != null
        ? DateTime.tryParse(_graduationDate!) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      locale: Locale(l10n.appLocale.name),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _graduationDate = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final success = await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          university: _universityController.text.trim(),
          specialization: _specializationController.text.trim(),
          address: _addressController.text.trim(),
          graduationDate: _graduationDate,
          category: _categoryController.text.trim(),
          gender: _gender,
          achievements: _achievementsController.text.trim(),
          photoPath: _photoPath,
          diplomaPath: _diplomaPath,
          passportCopyPath: _passportCopyPath,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      ref.invalidate(profileProvider);
      context.pop();
    } else if (mounted) {
      final error = ref.read(profileControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiErrorHandler.readableMessage(error)),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(profileControllerProvider);
    final isLoading = state.isLoading;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentProfile = widget.currentProfile.profile;
    ImageProvider<Object>? profileImage;
    if (_photoPath != null) {
      profileImage = FileImage(File(_photoPath!));
    } else if (currentProfile?.photoUrl != null) {
      profileImage = NetworkImage(currentProfile!.photoUrl!);
    }

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.profileEditTitle,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            if (isLoading)
              const SizedBox(
                width: 48,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: _submit,
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: AnimatedPressable(
                  onTap: _pickPhoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 4,
                          ),
                          image: profileImage != null
                              ? DecorationImage(
                                  image: profileImage,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: profileImage == null
                            ? Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Colors.white.withValues(alpha: 0.3),
                              )
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(
                      l10n.universityLabel,
                      _universityController,
                      Icons.school_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      l10n.specializationLabel,
                      _specializationController,
                      Icons.work_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      l10n.categoryLabel,
                      _categoryController,
                      Icons.workspace_premium_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickGraduationDate,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          l10n.graduationDateLabel,
                          TextEditingController(text: _graduationDate ?? ''),
                          Icons.calendar_today_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      dropdownColor: TeacherAppColors.slate800,
                      decoration: InputDecoration(
                        labelText: l10n.genderLabel,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(
                          Icons.badge_rounded,
                          color: colorScheme.primary.withValues(alpha: 0.7),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(l10n.genderLabelText('male')),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(l10n.genderLabelText('female')),
                        ),
                      ],
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      l10n.addressLabel,
                      _addressController,
                      Icons.location_on_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      l10n.achievementsLabel,
                      _achievementsController,
                      Icons.emoji_events_rounded,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildUploadCard(
                title: l10n.diplomaTitle,
                currentFileLabel: _diplomaPath?.split('/').last,
                fallbackLabel: currentProfile?.diplomaUrl != null
                    ? l10n.alreadyUploadedLabel
                    : null,
                icon: Icons.workspace_premium_outlined,
                onPick: () => _pickDocument(
                  onPicked: (path) => setState(() => _diplomaPath = path),
                ),
                onClear: _diplomaPath == null
                    ? null
                    : () => setState(() => _diplomaPath = null),
              ),
              const SizedBox(height: 16),
              _buildUploadCard(
                title: l10n.passportCopyTitle,
                currentFileLabel: _passportCopyPath?.split('/').last,
                fallbackLabel: currentProfile?.passportUrl != null
                    ? l10n.alreadyUploadedLabel
                    : null,
                icon: Icons.contact_page_outlined,
                onPick: () => _pickDocument(
                  onPicked: (path) => setState(() => _passportCopyPath = path),
                ),
                onClear: _passportCopyPath == null
                    ? null
                    : () => setState(() => _passportCopyPath = null),
              ),
              const SizedBox(height: 32),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          color: colorScheme.primary.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required IconData icon,
    required VoidCallback onPick,
    required VoidCallback? onClear,
    String? currentFileLabel,
    String? fallbackLabel,
  }) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentFileLabel ??
                          fallbackLabel ??
                          l10n.documentNotSelected,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              if (onClear != null)
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 20),
                )
              else
                IconButton(
                  onPressed: onPick,
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
