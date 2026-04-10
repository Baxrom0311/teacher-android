import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../providers/conference_provider.dart';

class ConferenceCreateScreen extends ConsumerStatefulWidget {
  const ConferenceCreateScreen({super.key});

  @override
  ConsumerState<ConferenceCreateScreen> createState() =>
      _ConferenceCreateScreenState();
}

class _ConferenceCreateScreenState
    extends ConsumerState<ConferenceCreateScreen> {
  final _locationController = TextEditingController();
  final List<Map<String, dynamic>> _slots = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.conferenceCreateTitle),
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
              l10n.conferenceSelectDateLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                DateFormat(
                  'yyyy-MM-dd',
                  l10n.intlLocaleTag,
                ).format(_selectedDate),
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  locale: Locale(l10n.appLocale.name),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.conferenceLocationLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: l10n.conferenceLocationHint,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.conferenceSlotsLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: _addSlot,
                  icon: Icon(Icons.add_circle, color: colorScheme.primary),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _slots.length,
              itemBuilder: (context, index) {
                final slot = _slots[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: theme.cardColor,
                  child: ListTile(
                    title: Text(
                      '${slot['start_time']} - ${slot['end_time']}',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () => setState(() => _slots.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
            if (_slots.isEmpty)
              Text(
                l10n.conferenceNoSlots,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: _slots.isEmpty ? null : _saveConferences,
                child: Text(l10n.saveAction),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSlot() async {
    final startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTime == null) return;
    if (!mounted) return;
    final endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: startTime.hour,
        minute: startTime.minute + 20,
      ),
    );
    if (endTime == null) return;

    setState(() {
      _slots.add({
        'slot_date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'start_time':
            '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
        'end_time':
            '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      });
    });
  }

  Future<void> _saveConferences() async {
    final success = await ref
        .read(conferenceCreateControllerProvider.notifier)
        .createSlots(slots: _slots, location: _locationController.text);
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.conferenceCreateSuccess)),
      );
    }
  }
}
