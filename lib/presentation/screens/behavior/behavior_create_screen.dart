import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_school_app/core/constants/app_colors.dart';

import '../../../core/localization/app_localizations.dart';
import '../../providers/behavior_provider.dart';

class BehaviorCreateScreen extends ConsumerStatefulWidget {
  const BehaviorCreateScreen({super.key});

  @override
  ConsumerState<BehaviorCreateScreen> createState() => _BehaviorCreateScreenState();
}

class _BehaviorCreateScreenState extends ConsumerState<BehaviorCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController(text: '5');

  String _type = 'positive';
  DateTime _incidentDate = DateTime.now();

  @override
  void dispose() {
    _studentIdCtrl.dispose();
    _categoryCtrl.dispose();
    _descriptionCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final theme = Theme.of(context);
    final state = ref.watch(behaviorListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.behaviorCreateTitle),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: state.isCreating ? null : _submit,
            child: state.isCreating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.behaviorSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type toggle
            Text(l10n.behaviorType, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'positive',
                  label: Text(l10n.behaviorPositive),
                  icon: const Icon(Icons.thumb_up_rounded, size: 18),
                ),
                ButtonSegment(
                  value: 'negative',
                  label: Text(l10n.behaviorNegative),
                  icon: const Icon(Icons.thumb_down_rounded, size: 18),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),

            const SizedBox(height: 20),

            // Student ID
            TextFormField(
              controller: _studentIdCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.behaviorStudentId,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? '' : null,
            ),

            const SizedBox(height: 16),

            // Category
            TextFormField(
              controller: _categoryCtrl,
              decoration: InputDecoration(
                labelText: l10n.behaviorCategory,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty) ? '' : null,
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionCtrl,
              decoration: InputDecoration(
                labelText: l10n.behaviorDescription,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Points
            TextFormField(
              controller: _pointsCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.behaviorPoints,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '';
                final n = int.tryParse(v);
                if (n == null || n < 0 || n > 100) return '';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                '${_incidentDate.day.toString().padLeft(2, '0')}.${_incidentDate.month.toString().padLeft(2, '0')}.${_incidentDate.year}',
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: Text(l10n.behaviorDate),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _incidentDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _incidentDate = picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final points = int.parse(_pointsCtrl.text.trim());
    final dateStr =
        '${_incidentDate.year}-${_incidentDate.month.toString().padLeft(2, '0')}-${_incidentDate.day.toString().padLeft(2, '0')}';

    final ok = await ref.read(behaviorListProvider.notifier).createIncident(
          studentId: int.parse(_studentIdCtrl.text.trim()),
          type: _type,
          category: _categoryCtrl.text.trim(),
          description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
          points: _type == 'positive' ? points : -points,
          incidentDate: dateStr,
        );

    if (mounted) {
      if (ok) {
        Navigator.of(context).pop();
      } else {
        final l10n = AppLocalizationsRegistry.instance;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.behaviorCreateFailed)),
        );
      }
    }
  }
}
