import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:workspace/core/constants/repeat_freq_enum.dart';
import 'package:workspace/core/utils/app_logger.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/features/pets/providers/appointment_provider.dart';
import 'package:workspace/features/pets/widgets/calendar/appointment_allday_field.dart';
import 'package:workspace/features/pets/widgets/calendar/appointment_desc_field.dart';
import 'package:workspace/features/pets/widgets/calendar/appointment_title_section.dart';
import 'package:workspace/features/pets/widgets/calendar/date_time_picker.dart';
import 'package:workspace/features/pets/widgets/calendar/repeat_rule_picket.dart';

part 'appointment_editor_helper.dart';

class AppointmentEditor extends StatefulWidget {
  final String mode;
  final PetAppointment? event;
  final DateTime selectedDate;
  final String petId;

  final void Function(BuildContext)? onDelete;

  const AppointmentEditor({
    super.key,
    required this.selectedDate,
    required this.petId,
  }) : mode = 'add',
       event = null,
       onDelete = null;

  const AppointmentEditor.edit({
    super.key,
    required this.event,
    required this.onDelete,
    required this.selectedDate,
    required this.petId,
  }) : mode = 'edit';

  @override
  State<AppointmentEditor> createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor>
    with AppointmentEditorHelper {
  late PetAppointment _currentEvent;
  bool _isEditMode = false;
  int? selectedRepeat = -1;
  Color pickedColor = Color(0xff443a49);
  static final _apptFormKey = GlobalKey<FormState>(debugLabel: 'apptForm');

  @override
  void initState() {
    super.initState();

    if (widget.mode == 'edit') {
      _isEditMode = true;
      _currentEvent = widget.event!.copyWith();
      appLogger.i('_currentEvent ${_currentEvent.toString()}');
      _getRecurrenceRule();
    } else {
      _currentEvent = PetAppointment.empty(petId: widget.petId);
      _initDateTime();
    }
  }

  void _initDateTime() {
    final now = DateTime.now();

    final startDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      now.hour,
      now.minute,
    );

    final endDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      now.hour + 1,
      now.minute,
    );

    setState(() {
      _currentEvent.from = startDateTime;
      _currentEvent.to = endDateTime;
    });
  }

  void _submit() async {
    appLogger.i('In submit');
    if (_apptFormKey.currentState?.validate() ?? false) {
      _apptFormKey.currentState!.save();

      final provider = context.read<PetAppointmentProvider>();

      if (_isEditMode) {
        appLogger.i('Save appt');
        provider.updateEvent(widget.event!, _currentEvent);
      } else {
        appLogger.i('Add new appt');
        provider.addEvent(_currentEvent);
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  void _getRecurrenceRule() {
    final rule = _currentEvent.recurrenceRule;

    if (rule == null || rule.isEmpty || !rule.contains('=')) {
      setState(() => selectedRepeat = -1);
      return;
    }

    final parts = rule.split('=');
    if (parts.length > 1) {
      final freqString = parts[1].split(';')[0].toUpperCase();

      final index = Frequency.values.indexWhere(
        (f) => f.name.toUpperCase() == freqString,
      );

      setState(() => selectedRepeat = index);
    } else {
      setState(() => selectedRepeat = -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Appointment' : 'New Appointment',
        ),
      ),
      body: Form(
        key: _apptFormKey,

        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppointmentTitleSection(
                currentEvent: _currentEvent,
                onTap: () => _showColourPicker(pickedColor),
              ),

              const Divider(
                height: 1.0,
                thickness: 1,
              ),

              AppointmentAllDayField(
                currentEvent: _currentEvent,
                onChanged: (bool value) {
                  setState(() {
                    _currentEvent.isAllDay = value;
                  });
                },
              ),

              ApptDateTimePicker(
                date: _currentEvent.from!,
                isAllDay: _currentEvent.isAllDay!,
                onDateTap: () => _pickDate(true),
                onTimeTap: () => _pickTime(true),
              ),

              ApptDateTimePicker(
                date: _currentEvent.to!,
                isAllDay: _currentEvent.isAllDay!,
                onDateTap: () => _pickDate(false),
                onTimeTap: () => _pickTime(false),
              ),

              const Divider(
                height: 1.0,
                thickness: 1,
              ),

              RepeatRulePicker(
                selectedRepeat: selectedRepeat,

                onSelected: (newIndex) {
                  if (newIndex == null || newIndex == -1) {
                    setState(() {
                      selectedRepeat = -1;
                      _currentEvent.recurrenceRule = '';
                    });
                    return;
                  }

                  String freq = Frequency.values[newIndex].name.toUpperCase();

                  setState(() {
                    selectedRepeat = newIndex;
                    _currentEvent.recurrenceRule = 'FREQ=$freq';
                  });
                },
              ),

              const Divider(
                height: 1.0,
                thickness: 1,
              ),

              DynamicDescField(
                pickedColor: pickedColor,
                currentEvent: _currentEvent,
              ),

              const SizedBox(height: 30),

              Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEditMode ? 'Save' : 'Add Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PetAppointment get currentEvent => _currentEvent;
}
