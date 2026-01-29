import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/core/constants/repeat_freq_enum.dart';
import 'package:workspace/core/utils/app_logger.dart';
import 'package:workspace/core/widgets/confirmation_alert.dart';
import 'package:workspace/core/widgets/custom_bottom_sheet.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/data/models/sheet_item.dart';
import 'package:workspace/features/pets/providers/appointment_provider.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/allday_field.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/custom_repeat_picker.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/date_time_picker.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/description_field.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/repeat_rule_picket.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/save_options_dialog.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/title_section.dart';

part 'widgets/appointment_form_fields/appointment_editor_helper.dart';

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
  int selectedRepeat = -1;
  Color pickedColor = Color(0xff443a49);
  static final _apptFormKey = GlobalKey<FormState>(debugLabel: 'apptForm');

  @override
  void initState() {
    super.initState();

    if (widget.mode == 'edit') {
      _isEditMode = true;

      final duration = widget.event!.to!.difference(widget.event!.from!);

      _currentEvent = widget.event!.copyWith(
        from: widget.selectedDate,
        to: widget.selectedDate.add(duration),
        id: widget.event!.id,
      );
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
    if (_apptFormKey.currentState?.validate() ?? false) {
      final provider = context.read<PetAppointmentProvider>();
      _apptFormKey.currentState!.save();

      if (_isEditMode) {
        if (_currentEvent.recurrenceId != null) {
          provider.updateEvent(widget.event!, _currentEvent);
        } else if (_currentEvent.recurrenceRule != null &&
            _currentEvent.recurrenceRule!.isNotEmpty) {
          final choice = await _showSaveOptionsDialog();

          if (choice == null) return;

          if (choice == 'series') {
            provider.updateEvent(widget.event!, _currentEvent);
          } else if (choice == 'occurrence') {
            final master = widget.event!;

            final updatedDates = List<DateTime>.from(
              master.exceptionDates ?? [],
            );

            if (!updatedDates.contains(widget.selectedDate)) {
              updatedDates.add(widget.selectedDate);
            }

            final updatedMaster = master.copyWith(
              exceptionDates: updatedDates,
            );

            provider.updateEvent(master, updatedMaster);

            final exception = _currentEvent.copyWith(
              recurrenceId: master.id,
              recurrenceRule: null,
              exceptionDates: [],
            );

            provider.addEvent(exception);
          }
        } else {
          provider.updateEvent(widget.event!, _currentEvent);
        }
      } else {
        provider.addEvent(_currentEvent);
      }
      if (mounted) Navigator.pop(context);
      return;
    }

    appLogger.w('Validation failed');
  }

  void _getRecurrenceRule() {
    final rule = _currentEvent.recurrenceRule;

    if (rule == null || rule.isEmpty || !rule.contains('=')) {
      setState(() => selectedRepeat = -1);
      return;
    }

    try {
      final RecurrenceProperties props = SfCalendar.parseRRule(
        rule,
        _currentEvent.from!,
      );

      if (props.interval > 1 ||
          props.recurrenceRange != RecurrenceRange.noEndDate) {
        setState(() => selectedRepeat = 4);
      } else {
        setState(
          () => selectedRepeat = RecurrenceType.values.indexOf(
            props.recurrenceType,
          ),
        );
      }
    } catch (e) {
      setState(() => selectedRepeat = -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Appointment' : 'New Appointment',
        ),

        actions: <Widget>[
          if (_isEditMode)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Delete appointment',
              onPressed: () => _showDeleteOptions(context),
            ),
        ],
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

                onSelected: (newIndex) async {
                  if (newIndex == null || newIndex == -1) {
                    setState(() {
                      selectedRepeat = -1;
                      _currentEvent.recurrenceRule = null;
                    });
                    return;
                  }

                  final selectedFreq = Frequency.values[newIndex];

                  if (selectedFreq == Frequency.custom) {
                    await _openCustomRecurrencePicker(newIndex);
                  } else {
                    final RecurrenceProperties properties =
                        RecurrenceProperties(
                          startDate: _currentEvent.from!,
                          recurrenceType: RecurrenceType.values[newIndex],
                          interval: 1,
                        );

                    setState(() {
                      selectedRepeat = newIndex;
                      _currentEvent.recurrenceRule = SfCalendar.generateRRule(
                        properties,
                        _currentEvent.from!,
                        _currentEvent.to!,
                      );
                    });
                  }
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

  @override
  int get selectedRepeatIndex => selectedRepeat;

  @override
  set currentEvent(PetAppointment value) {
    setState(() {
      _currentEvent = value;
    });
  }

  @override
  set selectedRepeatIndex(int value) {
    setState(() {
      selectedRepeat = value;
    });
  }
}
