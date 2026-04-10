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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.profileEditTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickPhoto,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.outline,
                    backgroundImage: profileImage,
                    child:
                        _photoPath == null && currentProfile?.photoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              l10n.universityLabel,
              _universityController,
              Icons.school,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.specializationLabel,
              _specializationController,
              Icons.work,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.categoryLabel,
              _categoryController,
              Icons.workspace_premium_outlined,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickGraduationDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                    text: _graduationDate ?? '',
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.graduationDateLabel,
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    hintText: l10n.dateInputHint,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: InputDecoration(
                labelText: l10n.genderLabel,
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: 'male',
                  child: Text(l10n.genderLabelText('male')),
                ),
                DropdownMenuItem<String>(
                  value: 'female',
                  child: Text(l10n.genderLabelText('female')),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.addressLabel,
              _addressController,
              Icons.location_on,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.achievementsLabel,
              _achievementsController,
              Icons.emoji_events,
              maxLines: 3,
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      style: TextStyle(color: theme.colorScheme.onSurface),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.upload_file_outlined),
                label: Text(l10n.selectAction),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentFileLabel ?? fallbackLabel ?? l10n.documentNotSelected,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          if (onClear != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: onClear, child: Text(l10n.cancel)),
            ),
          ],
        ],
      ),
    );
  }
}
