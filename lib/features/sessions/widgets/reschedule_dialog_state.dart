import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';
import 'package:physioghar_therapist/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar_therapist/features/sessions/widgets/picker_field.dart';
import 'package:physioghar_therapist/features/sessions/widgets/reschedule_dialog.dart';

class RescheduleDialogState extends State<RescheduleDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.session.date;
    _selectedTime = parseTime(widget.session.time) ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reschedule Session', style: AppTypography.headingSmall()),
            const SizedBox(height: 14),
            Text(
              'Update the schedule for ${widget.session.patientName}.',
              style: AppTypography.bodyMedium(color: AppColors.slateMid),
            ),
            const SizedBox(height: 14),
            PickerField(
              label: 'Date',
              value: DateFormatter.formatShortDate(_selectedDate),
              icon: Icons.calendar_month_outlined,
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            PickerField(
              label: 'Time',
              value: _selectedTime.format(context),
              icon: Icons.access_time_outlined,
              onTap: _pickTime,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: AppTypography.bodySmall(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context, false);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      foregroundColor: AppColors.slate,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.buttonText(color: AppColors.slate),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      final newTime = _selectedTime.format(context);
                      final isUnavailable = widget.scheduledSlots.any(
                        (slot) =>
                            slot.sessionId != widget.session.id &&
                            slot.date.year == _selectedDate.year &&
                            slot.date.month == _selectedDate.month &&
                            slot.date.day == _selectedDate.day &&
                            sameTime(slot.time, newTime) &&
                            slot.status != SlotStatus.open,
                      );

                      if (isUnavailable) {
                        setState(() {
                          _errorMessage =
                              'This date and time is not available.';
                        });
                        return;
                      }

                      widget.onSave(_selectedDate, newTime);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: AppColors.pine,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Save', style: AppTypography.buttonText()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(today) ? today : _selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (pickedDate == null || !mounted) return;
    setState(() {
      _selectedDate = pickedDate;
      _errorMessage = null;
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime == null || !mounted) return;
    setState(() {
      _selectedTime = pickedTime;
      _errorMessage = null;
    });
  }
}