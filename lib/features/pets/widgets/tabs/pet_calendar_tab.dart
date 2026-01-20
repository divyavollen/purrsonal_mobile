import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/features/pets/widgets/calendar/appointment_editor.dart';
import 'package:workspace/features/pets/widgets/calendar/custom_header.dart';
import 'package:workspace/features/pets/widgets/calendar/schedule_view_month_header.dart';

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

            onViewChanged: (ViewChangedDetails details) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _headerText = DateFormat('MMMM yyyy').format(
                    details.visibleDates[details.visibleDates.length ~/ 2],
                  );
                });
              });
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
              CalendarView.schedule,
            ],
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            scheduleViewSettings: const ScheduleViewSettings(
              appointmentItemHeight: 60,
              monthHeaderSettings: MonthHeaderSettings(
                height: 50,
              ),
            ),
            scheduleViewMonthHeaderBuilder: (context, details) =>
                CustomScheduleViewMonthHeader(details: details),

            //dataSource: EventDatasource(_getDataSource()),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.calendarCell ||
                  details.targetElement == CalendarElement.appointment) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentEditor(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
