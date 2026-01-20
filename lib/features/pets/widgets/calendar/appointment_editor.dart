import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:workspace/core/constants/app_dimensions.dart';
import 'package:workspace/data/models/hive/event.dart';

class AppointmentEditor extends StatefulWidget {
  final String mode;
  final Event? event;
  final void Function(BuildContext)? onDelete;

  const AppointmentEditor({
    super.key,
  }) : mode = 'add',
       event = null,
       onDelete = null;

  const AppointmentEditor.edit({
    super.key,
    required this.event,
    required this.onDelete,
  }) : mode = 'edit';

  @override
  State<AppointmentEditor> createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  late Event _currentEvent;
  bool _isEditMode = false;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();

    if (widget.mode == 'edit') {
      _isEditMode = true;
      _currentEvent = widget.event!.copyWith();
    } else {
      DateTime now = DateTime.now();
      DateTime hourFromNow = DateTime.now().add(const Duration(hours: 1));

      _currentEvent = Event.empty();
      _currentEvent.from = now;
      _currentEvent.to = hourFromNow;
      _startTime = TimeOfDay.fromDateTime(now);
      _endTime = TimeOfDay.fromDateTime(hourFromNow);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color pickedColor = Color(0xff443a49);

    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          ListTile(
            leading: Text(''),
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            title: TextField(
              onChanged: (String value) {
                _currentEvent.eventName = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: headLineSmallFontSize,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: 'Add title',
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
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
                      value: _currentEvent.isAllDay,
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
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    child: Text(
                      DateFormat(
                        'EEE, MMM dd yyyy',
                      ).format(_currentEvent.from!),
                      textAlign: TextAlign.left,
                    ),
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _currentEvent.from!,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (date != null && date != _currentEvent.from) {
                        setState(() {
                          final Duration difference = _currentEvent.to!
                              .difference(
                                _currentEvent.from!,
                              );
                          _currentEvent.from = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _startTime.hour,
                            _startTime.minute,
                            0,
                          );
                          _currentEvent.to = _currentEvent.from!.add(
                            difference,
                          );
                          _endTime = TimeOfDay(
                            hour: _currentEvent.to!.hour,
                            minute: _currentEvent.to!.minute,
                          );
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _currentEvent.isAllDay
                      ? const Text('')
                      : GestureDetector(
                          child: Text(
                            DateFormat('hh:mm a').format(_currentEvent.from!),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: _startTime.hour,
                                minute: _startTime.minute,
                              ),
                            );

                            if (time != null && time != _startTime) {
                              setState(() {
                                _startTime = time;
                                final Duration difference = _currentEvent.to!
                                    .difference(
                                      _currentEvent.from!,
                                    );
                                _currentEvent.from = DateTime(
                                  _currentEvent.from!.year,
                                  _currentEvent.from!.month,
                                  _currentEvent.from!.day,
                                  _startTime.hour,
                                  _startTime.minute,
                                  0,
                                );
                                _currentEvent.to = _currentEvent.from!.add(
                                  difference,
                                );
                                _endTime = TimeOfDay(
                                  hour: _currentEvent.to!.hour,
                                  minute: _currentEvent.to!.minute,
                                );
                              });
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Text(''),
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(_currentEvent.to!),
                      textAlign: TextAlign.left,
                    ),
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _currentEvent.to!,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (date != null && date != _currentEvent.to!) {
                        setState(() {
                          final Duration difference = _currentEvent.to!
                              .difference(
                                _currentEvent.from!,
                              );
                          _currentEvent.to = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _endTime.hour,
                            _endTime.minute,
                            0,
                          );
                          if (_currentEvent.to!.isBefore(_currentEvent.from!)) {
                            _currentEvent.from = _currentEvent.to!.subtract(
                              difference,
                            );
                            _startTime = TimeOfDay(
                              hour: _currentEvent.from!.hour,
                              minute: _currentEvent.from!.minute,
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _currentEvent.isAllDay
                      ? const Text('')
                      : GestureDetector(
                          child: Text(
                            DateFormat('hh:mm a').format(_currentEvent.to!),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: _endTime.hour,
                                minute: _endTime.minute,
                              ),
                            );

                            if (time != null && time != _endTime) {
                              setState(() {
                                _endTime = time;
                                final Duration difference = _currentEvent.to!
                                    .difference(
                                      _currentEvent.from!,
                                    );
                                _currentEvent.to = DateTime(
                                  _currentEvent.to!.year,
                                  _currentEvent.to!.month,
                                  _currentEvent.to!.day,
                                  _endTime.hour,
                                  _endTime.minute,
                                  0,
                                );
                                if (_currentEvent.to!.isBefore(
                                  _currentEvent.from!,
                                )) {
                                  _currentEvent.from = _currentEvent.to!
                                      .subtract(difference);
                                  _startTime = TimeOfDay(
                                    hour: _currentEvent.from!.hour,
                                    minute: _currentEvent.from!.minute,
                                  );
                                }
                              });
                            }
                          },
                        ),
                ),
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
              Icons.lens,
              color: _currentEvent.background,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickedColor,
                      onColorChanged: (value) =>
                          setState(() => pickedColor = value),
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        setState(() => _currentEvent.background = pickedColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
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
            title: TextField(
              onChanged: (String value) {
                _currentEvent.description = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Add description',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          const Divider(
            height: 1.0,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
