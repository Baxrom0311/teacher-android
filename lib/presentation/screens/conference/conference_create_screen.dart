import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../providers/conference_provider.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';

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

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.conferenceCreateTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(title: l10n.conferenceSelectDateLabel),
              AnimatedPressable(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    locale: Locale(l10n.appLocale.name),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: PremiumCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd',
                          l10n.intlLocaleTag,
                        ).format(_selectedDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.edit_calendar_rounded,
                        size: 18,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _SectionTitle(title: l10n.conferenceLocationLabel),
              _InputField(
                controller: _locationController,
                hintText: l10n.conferenceLocationHint,
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(title: l10n.conferenceSlotsLabel),
                  AnimatedPressable(
                    onTap: _addSlot,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.addAction,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_slots.isEmpty)
                PremiumCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_time_rounded,
                          size: 32,
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.conferenceNoSlots,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _slots.length,
                  itemBuilder: (context, index) {
                    final slot = _slots[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SlotItem(
                        time: '${slot['start_time']} - ${slot['end_time']}',
                        onDelete: () => setState(() => _slots.removeAt(index)),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedPressable(
              onTap: _slots.isEmpty ? null : _saveConferences,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _slots.isEmpty
                        ? [
                            colorScheme.surfaceContainerHighest,
                            colorScheme.surfaceContainerHighest,
                          ]
                        : [colorScheme.primary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    if (_slots.isNotEmpty)
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    l10n.saveAction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
      context.pop();
      AppFeedback.showSuccess(context, context.l10n.conferenceCreateSuccess);
    }
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

  const _InputField({required this.controller, required this.hintText});

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
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _SlotItem extends StatelessWidget {
  final String time;
  final VoidCallback onDelete;

  const _SlotItem({required this.time, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: colorScheme.error,
            size: 22,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
