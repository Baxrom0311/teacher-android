import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import '../../../core/constants/api_constants.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/meal_provider.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';
import 'dart:ui';

class MealsListScreen extends ConsumerStatefulWidget {
  const MealsListScreen({super.key});

  @override
  ConsumerState<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends ConsumerState<MealsListScreen> {
  final _mealNameController = TextEditingController();
  final _recipeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];

  @override
  void dispose() {
    _mealNameController.dispose();
    _recipeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(images);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _submitMealReport(int groupId, String mealType) async {
    final l10n = context.l10n;
    final mealName = _mealNameController.text.trim();
    if (mealName.isEmpty) {
      AppFeedback.showError(context, l10n.mealsNameRequired);
      return;
    }

    final success = await ref.read(mealControllerProvider.notifier).storeMeal(
          groupId: groupId,
          mealType: mealType,
          mealName: mealName,
          recipe: _recipeController.text.trim(),
          files: _selectedFiles,
        );

    if (success && mounted) {
      AppFeedback.showSuccess(context, l10n.mealsSavedSuccess);
      setState(() {
        _selectedFiles = [];
        _mealNameController.clear();
        _recipeController.clear();
      });
      ref.invalidate(mealsIndexProvider);
    } else if (mounted) {
      final error = ref.read(mealControllerProvider).error;
      AppFeedback.showError(context, ApiErrorHandler.readableMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mealsAsync = ref.watch(mealsIndexProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.mealsReportTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: mealsAsync.when(
          data: (data) {
            if (data.groups.isEmpty) {
              return AppEmptyView(
                message: l10n.mealsNoGroupsMessage,
                icon: Icons.groups_rounded,
              );
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_mealNameController.text.isEmpty && data.selectedName != null) {
                _mealNameController.text = data.selectedName!;
              }
              if (_recipeController.text.isEmpty && data.selectedRecipe != null) {
                _recipeController.text = data.selectedRecipe!;
              }
            });

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _SectionTitle(title: l10n.mealsDateLabel(data.today)),
                   const SizedBox(height: 8),
                  _buildSelectors(data, colorScheme),
                  const SizedBox(height: 24),
                  
                  _SectionTitle(title: l10n.mealsNameLabel),
                  _InputField(
                    controller: _mealNameController,
                    hintText: l10n.mealsNameHint,
                  ),
                  const SizedBox(height: 20),

                  _SectionTitle(title: l10n.mealsRecipeLabel),
                  _InputField(
                    controller: _recipeController,
                    hintText: l10n.mealsRecipeHint,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionTitle(title: l10n.mealsImagesLabel),
                      AnimatedPressable(
                        onTap: _pickImages,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_a_photo_rounded, size: 18, color: colorScheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                l10n.mealsAddImageAction,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_selectedFiles.isNotEmpty)
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _selectedFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                    image: DecorationImage(
                                      image: FileImage(File(_selectedFiles[index].path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -8,
                                  top: -8,
                                  child: AnimatedPressable(
                                    onTap: () => _removeFile(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: TeacherAppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  if (data.mediaByType[data.selectedType] != null &&
                      data.mediaByType[data.selectedType]!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle(title: l10n.mealsSystemImagesTitle),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.mediaByType[data.selectedType]!.length,
                        itemBuilder: (context, index) {
                          final media = data.mediaByType[data.selectedType]![index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: PremiumCard(
                              padding: EdgeInsets.zero,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  '${ApiConstants.baseUrl}/storage/${media.filePath}',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: AppLoadingView()),
          error: (err, st) => Center(
            child: AppErrorView(
              message: ApiErrorHandler.readableMessage(err),
              onRetry: () => ref.invalidate(mealsIndexProvider),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: mealsAsync.maybeWhen(
              data: (data) => AnimatedPressable(
                onTap: () => _submitMealReport(data.groupId, data.selectedType),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      l10n.mealsSaveAction,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectors(dynamic data, ColorScheme colorScheme) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _DropdownField<int>(
            value: data.groupId,
            label: l10n.mealsGroupLabel,
            items: (data.groups as List).map((g) => DropdownMenuItem<int>(value: g.id, child: Text(g.name))).toList(),
            onChanged: (v) {
              if (v == null) return;
              _mealNameController.clear();
              _recipeController.clear();
              ref.read(mealIndexParamsProvider.notifier).update((state) => {...state, 'group_id': v});
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _DropdownField<String>(
            value: data.selectedType,
            label: l10n.mealsTimeLabel,
            items: (data.mealTypes as List).map((m) => DropdownMenuItem<String>(
                  value: m.toString(),
                  child: Text(l10n.mealTypeLabel(m.toString())),
                )).toList(),
            onChanged: (v) {
              if (v == null) return;
              _mealNameController.clear();
              _recipeController.clear();
              ref.read(mealIndexParamsProvider.notifier).update((state) => {...state, 'meal_type': v});
            },
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const _InputField({required this.controller, required this.hintText, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({required this.value, required this.label, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary, size: 20),
              dropdownColor: theme.cardColor,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
