import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/profile_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class PortfolioWorkCreateScreen extends ConsumerStatefulWidget {
  const PortfolioWorkCreateScreen({super.key});

  @override
  ConsumerState<PortfolioWorkCreateScreen> createState() =>
      _PortfolioWorkCreateScreenState();
}

class _PortfolioWorkCreateScreenState
    extends ConsumerState<PortfolioWorkCreateScreen> {
  final _titleController = TextEditingController();
  final _publishedPlaceController = TextEditingController();
  final _coauthorSearchController = TextEditingController();

  String? _filePath;
  String? _publishedAt;
  bool _isSearchingCoauthors = false;
  Timer? _searchDebounce;
  List<TeacherCoauthorData> _coauthorResults = const [];
  List<TeacherCoauthorData> _selectedCoauthors = const [];

  @override
  void dispose() {
    _titleController.dispose();
    _publishedPlaceController.dispose();
    _coauthorSearchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _pickPublishedAt() async {
    final l10n = context.l10n;
    final initialDate = _publishedAt != null
        ? DateTime.tryParse(_publishedAt!) ?? DateTime.now()
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
        _publishedAt = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _searchCoauthors(String value) {
    _searchDebounce?.cancel();
    final query = value.trim();

    if (query.length < 2) {
      setState(() {
        _coauthorResults = const [];
        _isSearchingCoauthors = false;
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() {
        _isSearchingCoauthors = true;
      });

      try {
        final currentUserId = ref.read(authControllerProvider).user?.id;
        final results = await ref
            .read(profileRepositoryProvider)
            .lookupCoauthors(query);
        if (!mounted) return;

        final selectedIds = _selectedCoauthors.map((item) => item.id).toSet();
        setState(() {
          _coauthorResults = results
              .where(
                (item) =>
                    item.id != currentUserId && !selectedIds.contains(item.id),
              )
              .toList();
        });
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiErrorHandler.readableMessage(error)),
            backgroundColor: TeacherAppColors.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSearchingCoauthors = false;
          });
        }
      }
    });
  }

  void _addCoauthor(TeacherCoauthorData teacher) {
    setState(() {
      _selectedCoauthors = [..._selectedCoauthors, teacher];
      _coauthorResults = const [];
      _coauthorSearchController.clear();
    });
  }

  void _removeCoauthor(int id) {
    setState(() {
      _selectedCoauthors = _selectedCoauthors
          .where((item) => item.id != id)
          .toList();
    });
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.portfolioTitleRequired)));
      return;
    }

    final success = await ref
        .read(profileControllerProvider.notifier)
        .addWork(
          title: title,
          publishedAt: _publishedAt,
          publishedPlace: _publishedPlaceController.text.trim(),
          filePath: _filePath,
          coauthorIds: _selectedCoauthors.map((item) => item.id).toList(),
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.portfolioWorkAdded),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(profileControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.portfolioCreateTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.portfolioWorkTitleLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l10n.portfolioWorkTitleHint,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.portfolioPublishedPlaceLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _publishedPlaceController,
              decoration: InputDecoration(
                hintText: l10n.portfolioPublishedPlaceHint,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.portfolioPublishedDateLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickPublishedAt,
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _publishedAt ?? l10n.assessmentSelectDate,
                        style: TextStyle(
                          color: _publishedAt == null
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.portfolioCoauthorSearchTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _coauthorSearchController,
              onChanged: _searchCoauthors,
              decoration: InputDecoration(
                hintText: l10n.portfolioCoauthorSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            if (_isSearchingCoauthors) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
            if (_selectedCoauthors.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedCoauthors
                    .map(
                      (teacher) => InputChip(
                        label: Text(teacher.name),
                        onDeleted: () => _removeCoauthor(teacher.id),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (_coauthorResults.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  children: _coauthorResults
                      .map(
                        (teacher) => ListTile(
                          leading: Icon(
                            Icons.person_add_alt_1_outlined,
                            color: colorScheme.primary,
                          ),
                          title: Text(
                            teacher.name,
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          subtitle: Text(
                            [
                              teacher.passportNo,
                              teacher.phone,
                              teacher.email,
                            ].whereType<String>().join(' • '),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: () => _addCoauthor(teacher),
                            child: Text(l10n.addAction),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.pdfOnlyFileLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.uploadAction),
                ),
              ],
            ),
            if (_filePath != null) ...[
              const SizedBox(height: 8),
              ListTile(
                tileColor: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outline),
                ),
                leading: Icon(Icons.picture_as_pdf, color: colorScheme.error),
                title: Text(
                  _filePath!.split('/').last,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  onPressed: () => setState(() => _filePath = null),
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        l10n.saveAction,
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
    );
  }
}
