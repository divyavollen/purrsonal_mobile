part of 'appointment_editor.dart';

mixin AppointmentEditorHelper on State<AppointmentEditor> {
  PetAppointment get currentEvent;

  Future<void> _pickDate(bool isStart) async {
    final DateTime initialDate = isStart
        ? currentEvent.from!
        : currentEvent.to!;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      if (isStart) {
        currentEvent.from = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedDate.hour,
          pickedDate.minute,
          0,
        );
      } else {
        currentEvent.to = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedDate.hour,
          pickedDate.minute,
          0,
        );
      }

      final Duration difference = currentEvent.to!
          .difference(currentEvent.from!)
          .abs();

      if (currentEvent.to!.isBefore(currentEvent.from!)) {
        currentEvent.from = currentEvent.to!.subtract(difference);
      }
    });
  }

  Future<void> _pickTime(bool isStart) async {
    final DateTime initialDate = isStart
        ? currentEvent.from!
        : currentEvent.to!;

    appLogger.i('Inside _pickTime isStart $isStart');

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialDate.hour,
        minute: initialDate.minute,
      ),
    );

    if (pickedTime == null) return;

    setState(() {
      if (isStart) {
        currentEvent.from = DateTime(
          currentEvent.from!.year,
          currentEvent.from!.month,
          currentEvent.from!.day,
          pickedTime.hour,
          pickedTime.minute,
          0,
        );
      } else {
        currentEvent.to = DateTime(
          currentEvent.to!.year,
          currentEvent.to!.month,
          currentEvent.to!.day,
          pickedTime.hour,
          pickedTime.minute,
          0,
        );
      }

      final Duration difference = currentEvent.to!
          .difference(
            currentEvent.from!,
          )
          .abs();

      if (currentEvent.to!.isBefore(currentEvent.from!)) {
        currentEvent.from = currentEvent.to!.subtract(difference);
      }
    });
  }

  Future _showColourPicker(Color pickedColour) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a colour'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickedColour,
            onColorChanged: (value) => setState(() => pickedColour = value),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              setState(
                () => currentEvent.background = pickedColour,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
