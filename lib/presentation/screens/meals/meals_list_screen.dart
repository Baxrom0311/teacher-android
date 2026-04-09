import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/meal_provider.dart';
import '../../widgets/app_feedback.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.mealsNameRequired)));
      return;
    }

    final success = await ref
        .read(mealControllerProvider.notifier)
        .storeMeal(
          groupId: groupId,
          mealType: mealType,
          mealName: mealName,
          recipe: _recipeController.text.trim(),
          files: _selectedFiles,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.mealsSavedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      setState(() {
        _selectedFiles = [];
        _mealNameController.clear();
        _recipeController.clear();
      });
      ref.invalidate(mealsIndexProvider);
    } else if (mounted) {
      final error = ref.read(mealControllerProvider).error;
      final message = error == null
          ? l10n.errorGeneric
          : ApiErrorHandler.readableMessage(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mealsAsync = ref.watch(mealsIndexProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.mealsReportTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: mealsAsync.when(
        data: (data) {
          if (data.groups.isEmpty) {
            return AppEmptyView(
              message: l10n.mealsNoGroupsMessage,
              icon: Icons.groups_outlined,
            );
          }

          // Populate text fields if reading existing data.
          // Note: using WidgetsBinding to avoid modify state while building.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_mealNameController.text.isEmpty && data.selectedName != null) {
              _mealNameController.text = data.selectedName!;
            }
            if (_recipeController.text.isEmpty && data.selectedRecipe != null) {
              _recipeController.text = data.selectedRecipe!;
            }
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: theme.cardColor,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdowns(data),
                      const SizedBox(height: 16),
                      Text(
                        l10n.mealsDateLabel(data.today),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.mealsNameLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _mealNameController,
                        decoration: InputDecoration(
                          hintText: l10n.mealsNameHint,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.mealsRecipeLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _recipeController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: l10n.mealsRecipeHint,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.mealsImagesLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.add_a_photo),
                            label: Text(l10n.mealsAddImageAction),
                          ),
                        ],
                      ),
                      if (_selectedFiles.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedFiles.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                      top: 8.0,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_selectedFiles[index].path),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () => _removeFile(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorScheme.error,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.close,
                                          color: colorScheme.onError,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      if (data.mediaByType[data.selectedType] != null &&
                          data.mediaByType[data.selectedType]!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          l10n.mealsSystemImagesTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                data.mediaByType[data.selectedType]!.length,
                            itemBuilder: (context, index) {
                              final media =
                                  data.mediaByType[data.selectedType]![index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '${ApiConstants.baseUrl}/storage/${media.filePath}',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          onPressed: () => _submitMealReport(
                            data.groupId,
                            data.selectedType,
                          ),
                          child: Text(
                            l10n.mealsSaveAction,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => AppLoadingView(
          title: l10n.mealsLoadingTitle,
          subtitle: l10n.mealsLoadingSubtitle,
        ),
        error: (err, st) => AppErrorView(
          title: l10n.mealsLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(err),
          icon: Icons.restaurant_menu_outlined,
          onRetry: () => ref.invalidate(mealsIndexProvider),
        ),
      ),
    );
  }

  Widget _buildDropdowns(dynamic data) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            initialValue: data.groupId,
            decoration: InputDecoration(labelText: l10n.mealsGroupLabel),
            items: (data.groups as List)
                .map(
                  (g) =>
                      DropdownMenuItem<int>(value: g.id, child: Text(g.name)),
                )
                .toList(),
            onChanged: (v) {
              _mealNameController.clear();
              _recipeController.clear();
              ref
                  .read(mealIndexParamsProvider.notifier)
                  .update((state) => {...state, 'group_id': v});
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            initialValue: data.selectedType,
            decoration: InputDecoration(labelText: l10n.mealsTimeLabel),
            items: (data.mealTypes as List)
                .map(
                  (m) => DropdownMenuItem<String>(
                    value: m.toString(),
                    child: Text(l10n.mealTypeLabel(m.toString())),
                  ),
                )
                .toList(),
            onChanged: (v) {
              _mealNameController.clear();
              _recipeController.clear();
              ref
                  .read(mealIndexParamsProvider.notifier)
                  .update((state) => {...state, 'meal_type': v});
            },
          ),
        ),
      ],
    );
  }
}
