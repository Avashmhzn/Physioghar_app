import 'package:flutter/material.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/widgets/reschedule_dialog_state.dart';

class RescheduleDialog extends StatefulWidget {
  const RescheduleDialog({super.key, 
    required this.session,
    required this.scheduledSlots,
    required this.onSave,
  });

  final PhysioSession session;
  final List<AvailabilitySlot> scheduledSlots;
  final void Function(DateTime newDate, String newTime) onSave;

  @override
  State<RescheduleDialog> createState() => RescheduleDialogState();
}