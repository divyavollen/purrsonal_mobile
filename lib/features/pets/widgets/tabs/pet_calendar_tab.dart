import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/features/pets/datasource/event_datasource.dart';
import 'package:workspace/features/pets/providers/appointment_provider.dart';
import 'package:workspace/features/pets/providers/calendar_selection_provider.dart';
import 'package:workspace/features/pets/widgets/calendar/appointment_editor.dart';
import 'package:workspace/features/pets/widgets/calendar/custom_header.dart';

class PetCalendarTab extends StatefulWidget {
  const PetCalendarTab({super.key});

  @override
  State<PetCalendarTab> createState() => _PetCalendarTabState();
}

class _PetCalendarTabState extends State<PetCalendarTab> {
  final CalendarController _calendarController = CalendarController();
  String _headerText = '';

  @override
  void initState() {
    super.initState();
    _headerText = DateFormat('MMMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetAppointmentProvider>(
      builder: (context, provider, child) {
        final dataSource = AppointmentDatasource(provider.events);

        return Column(
          children: [
            CustomHeader(
              headerText: _headerText,
              controller: _calendarController,
              onViewChanged: () => setState(() {}),
            ),

            Expanded(
              child: SfCalendar(
                controller: _calendarController,
                view: CalendarView.month,

                headerHeight: 0,

                onViewChanged: (ViewChangedDetails details) =>
                    onViewChanged(details),

                onSelectionChanged:
                    (CalendarSelectionDetails calendarSelectionDetails) {
                      if (calendarSelectionDetails.date != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<CalendarSelectionProvider>().updateDate(
                            calendarSelectionDetails.date!,
                          );
                        });
                      }
                    },

                showCurrentTimeIndicator: true,
                firstDayOfWeek: 1,
                initialSelectedDate: DateTime.now(),
                minDate: DateTime(1995, 01, 01),

                viewHeaderHeight: 60,
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                ],
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  showAgenda: true,
                ),
                scheduleViewSettings: const ScheduleViewSettings(
                  appointmentItemHeight: 60,
                  monthHeaderSettings: MonthHeaderSettings(
                    height: 50,
                  ),
                ),

                dataSource: dataSource,
                key: ValueKey(provider.count),

                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.calendarCell) {
                    _calendarController.view = CalendarView.day;
                  } else if (details.targetElement ==
                      CalendarElement.appointment) {
                    final PetAppointment appointment = details.appointments![0];

                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => AppointmentEditor.edit(
                          event: appointment,
                          petId: appointment.petId,
                          selectedDate: appointment.from!,
                          onDelete: (context) {},
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void onViewChanged(ViewChangedDetails details) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _headerText = DateFormat('MMMM yyyy').format(
          details.visibleDates[details.visibleDates.length ~/ 2],
        );
      });
    });
  }
}
