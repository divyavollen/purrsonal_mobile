import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:workspace/core/constants/app_dimensions.dart';
import 'package:workspace/core/constants/repeat_freq_enum.dart';
import 'package:workspace/core/utils/app_logger.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/features/pets/providers/appointment_provider.dart';
import 'package:workspace/features/pets/validators/input_validator.dart';
import 'package:workspace/features/pets/widgets/calendar/date_time_picker.dart';
import 'package:workspace/features/pets/widgets/form/add_pet_input_builder.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.mode == 'edit') {
      _isEditMode = true;
      _currentEvent = widget.event!.copyWith();
      appLogger.i('_currentEvent ${_currentEvent.toString()}');
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
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final provider = context.read<PetAppointmentProvider>();

      if (_isEditMode) {
        provider.updateEvent(widget.event!, _currentEvent);
      } else {
        provider.addEvent(_currentEvent);
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditMode ? 'Edit Appointment' : 'New Appointment',
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () => _showColourPicker(pickedColor),
                child: Icon(
                  Icons.color_lens,
                  color: _currentEvent.background,
                  size: 24,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              title: InputBuilder.buildTextField(
                initialValue: _currentEvent.title,
                context,
                label: 'Add title',
                onChanged: (String value) {
                  _currentEvent.title = value;
                },
                onSaved: (val) => _currentEvent.title = val ?? '',
                maxLines: null,
                fontSize: headLineSmallFontSize,
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator: (val) =>
                    InputValidator.validateRequiredInput(val, 'title'),
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
            ),

            const Divider(
              height: 1.0,
              thickness: 1,
            ),

            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.access_time,
                color: Colors.black54,
              ),
              title: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: _currentEvent.isAllDay!,
                        onChanged: (bool value) {
                          setState(() {
                            _currentEvent.isAllDay = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
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

            ListTile(
              leading: Icon(
                Icons.repeat,
              ),
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
              title: Text('Repeat'),
            ),

            //TODO make this functional
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 2),
              leading: const SizedBox(width: 24),
              title: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Wrap(
                  spacing: 5.0,
                  children: List<Widget>.generate(Frequency.values.length, (
                    int index,
                  ) {
                    return ChoiceChip(
                      showCheckmark: true,
                      label: Text(
                        Frequency.values[index].name,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: selectedRepeat == index
                            ? FontWeight.w900
                            : FontWeight.normal,
                      ),
                      selected: selectedRepeat == index,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedRepeat = selected ? index : null;
                          _currentEvent.recurrenceRule =
                              'FREQ=${Frequency.values[index].name}';
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(
              height: 1.0,
              thickness: 1,
            ),

            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(
                Icons.subject,
                color: pickedColor,
              ),
              title: InputBuilder.buildTextField(
                context,
                initialValue: _currentEvent.description,
                label: 'Description',
                onChanged: (String value) {
                  _currentEvent.description = value;
                },
                onSaved: (val) => _currentEvent.description = val ?? '',
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                fontSize: headLineSmallFontSize,
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                validator: (val) => InputValidator.validateInput(val),
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
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
    );
  }

  @override
  PetAppointment get currentEvent => _currentEvent;
}
