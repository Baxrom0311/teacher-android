import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/profile_model.dart';
import '../../common/animated_pressable.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_feedback.dart';

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

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.portfolioCreateTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(l10n.portfolioWorkTitleLabel, _titleController, Icons.title_rounded),
                    const SizedBox(height: 20),
                    _buildTextField(l10n.portfolioPublishedPlaceLabel, _publishedPlaceController, Icons.location_on_rounded),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickPublishedAt,
                      child: AbsorbPointer(
                        child: _buildTextField(l10n.portfolioPublishedDateLabel, TextEditingController(text: _publishedAt ?? ''), Icons.calendar_today_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: l10n.portfolioCoauthorSearchTitle),
              const SizedBox(height: 12),
              PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(l10n.portfolioCoauthorSearchHint, _coauthorSearchController, Icons.search_rounded, onChanged: _searchCoauthors),
                    if (_isSearchingCoauthors)
                      const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
                    if (_selectedCoauthors.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedCoauthors.map((teacher) => _CoauthorChip(name: teacher.name, onDelete: () => _removeCoauthor(teacher.id))).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              if (_coauthorResults.isNotEmpty) ...[
                const SizedBox(height: 12),
                ..._coauthorResults.map((teacher) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PremiumCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Icon(Icons.person_add_rounded, color: colorScheme.primary, size: 20),
                      ),
                      title: Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      subtitle: Text(teacher.email ?? teacher.phone ?? '', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.4))),
                      trailing: AnimatedPressable(
                        onTap: () => _addCoauthor(teacher),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                          child: Text(l10n.addAction, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
              const SizedBox(height: 24),
              _SectionHeader(title: l10n.pdfOnlyFileLabel),
              const SizedBox(height: 12),
              _buildUploadCard(
                title: l10n.pdfOnlyFileLabel,
                currentFileLabel: _filePath?.split('/').last,
                icon: Icons.picture_as_pdf_rounded,
                onPick: _pickFile,
                onClear: _filePath == null ? null : () => setState(() => _filePath = null),
              ),
              const SizedBox(height: 40),
              AnimatedPressable(
                onTap: isLoading ? null : _submit,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                        : Text(l10n.saveAction.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {void Function(String)? onChanged}) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w600),
        prefixIcon: Icon(icon, color: colorScheme.primary.withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildUploadCard({required String title, required IconData icon, required VoidCallback onPick, required VoidCallback? onClear, String? currentFileLabel}) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  currentFileLabel ?? l10n.documentNotSelected,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                ),
              ],
            ),
          ),
          if (onClear != null)
            IconButton(onPressed: onClear, icon: const Icon(Icons.close_rounded, size: 20))
          else
            IconButton(onPressed: onPick, icon: const Icon(Icons.file_upload_outlined, size: 20, color: Colors.white)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _CoauthorChip extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;
  const _CoauthorChip({required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close_rounded, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
