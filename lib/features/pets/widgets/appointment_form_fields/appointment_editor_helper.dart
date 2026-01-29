part of '../../appointment_editor.dart';

mixin AppointmentEditorHelper on State<AppointmentEditor> {
  PetAppointment get currentEvent;
  int get selectedRepeatIndex;

  set currentEvent(PetAppointment value);
  set selectedRepeatIndex(int value);

  PetAppointmentProvider get appointmentProvider =>
      context.read<PetAppointmentProvider>();

  PetAppointment get masterEvent => widget.event!;
  DateTime get apptDate => widget.selectedDate;

  Future<void> _pickDate(bool isStart) async {
    final DateTime initialDate = isStart
        ? currentEvent.from!
        : currentEvent.to!;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 100),
    );

    if (pickedDate == null) return;

    setState(() {
      if (isStart) {
        currentEvent = currentEvent.copyWith(
          from: DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            currentEvent.from!.hour,
            currentEvent.from!.minute,
            0,
            0,
          ),
        );
      } else {
        currentEvent = currentEvent.copyWith(
          to: DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            currentEvent.to!.hour,
            currentEvent.to!.minute,
            0,
            0,
            0,
          ),
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

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialDate.hour,
        minute: initialDate.minute,
      ),
    );

    if (pickedTime == null) return;

    DateTime newTime = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
      pickedTime.hour,
      pickedTime.minute,
      0,
      0,
      0,
    );

    setState(() {
      DateTime newFrom = isStart ? newTime : currentEvent.from!;
      DateTime newTo = isStart ? currentEvent.to! : newTime;

      final Duration duration = newTo.difference(newFrom).abs();

      if (newTo.isBefore(newFrom)) {
        if (isStart) {
          newTo = newFrom.add(
            const Duration(hours: 1),
          );
        } else {
          newFrom = newTo.subtract(duration);
        }
      }

      currentEvent = currentEvent.copyWith(
        from: newFrom,
        to: newTo,
      );
    });
  }

  Future _showColourPicker(Color pickedColour) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a colour'),
        content: SingleChildScrollView(
          child: HueRingPicker(
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

  Future<void> _openCustomRecurrencePicker(int? newIndex) async {
    final RecurrenceProperties? properties =
        await showModalBottomSheet<RecurrenceProperties>(
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: CustomRepeatRulePicker(startDate: apptDate),
          ),
        );

    if (properties != null) {
      setState(() {
        selectedRepeatIndex = 4;
        currentEvent.recurrenceRule = SfCalendar.generateRRule(
          properties,
          currentEvent.from!,
          currentEvent.to!,
        );
      });
    }
  }

  Future<String?> _showSaveOptionsDialog() async {
    FocusScope.of(context).unfocus();

    final String? choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SaveOptionsDialog(),
    );

    return choice;
  }

  Future<void> _showDeleteOptions(BuildContext rootContext) async {
    if (currentEvent.recurrenceId != null ||
        currentEvent.recurrenceRule == null) {
      if (rootContext.mounted) {
        Navigator.pop(rootContext);
      }
      await appointmentProvider.deleteEvent(masterEvent);

      return;
    } else if (currentEvent.recurrenceRule != null &&
        currentEvent.recurrenceRule!.isNotEmpty) {
      List<SheetItem> bottomSheetItems = [
        SheetItem(
          leading: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text('Delete occurrence'),
          onTap: () {
            Navigator.pop(context);
            appointmentProvider.deleteOccurrence(masterEvent, apptDate);
            if (rootContext.mounted) {
              Navigator.pop(rootContext);
            }
          },
          padding: EdgeInsets.only(left: 25.0, top: 10.0),
        ),

        SheetItem(
          leading: Icon(
            Icons.delete_forever,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Delete series',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
            await _showConfirmation(rootContext);
          },
          padding: EdgeInsets.only(left: 25.0, top: 5.0, bottom: 10.0),
        ),
      ];

      await showModalBottomSheet(
        context: context,
        builder: (sheetContext) {
          return CustomBottomSheet(items: bottomSheetItems);
        },
      );
    }
  }

  Future<void> _showConfirmation(BuildContext rootContext) async {
    ConfirmationAlertDialog.showConfirmation(
      context,
      button1: 'CANCEL',
      button2: 'DELETE ALL',
      confirmationMessage: 'This will remove all appointments in this series.',
      icon: Icons.warning,
      onPressed: () async {
        Navigator.pop(context);
        await appointmentProvider.deleteEvent(masterEvent);

        if (rootContext.mounted) {
          Navigator.pop(rootContext);
        }
      },
    );
  }
}
