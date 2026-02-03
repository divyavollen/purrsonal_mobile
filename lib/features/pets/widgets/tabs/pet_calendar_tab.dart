import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/core/constants/app_dimensions.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/features/pets/appointment_editor.dart';
import 'package:workspace/features/pets/datasource/appointment_datasource.dart';
import 'package:workspace/features/pets/providers/appointment_provider.dart';
import 'package:workspace/features/pets/providers/calendar_selection_provider.dart';
import 'package:workspace/features/pets/widgets/appointment_form_fields/custom_header.dart';

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
  void dispose() {
    _calendarController.dispose();
    super.dispose();
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
              onHeaderDateSelect: () => onHeaderDateSelect(),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => ExcludeSemantics(
                  child: SfCalendar(
                    controller: _calendarController,
                    view: CalendarView.month,

                    headerHeight: 0,

                    onViewChanged: (ViewChangedDetails details) =>
                        onViewChanged(details),

                    onSelectionChanged:
                        (
                          CalendarSelectionDetails calendarSelectionDetails,
                        ) {
                          if (calendarSelectionDetails.date != null) {
                            WidgetsBinding.instance.addPostFrameCallback((
                              _,
                            ) {
                              context
                                  .read<CalendarSelectionProvider>()
                                  .updateDate(
                                    calendarSelectionDetails.date!,
                                  );
                            });
                          }
                        },

                    showCurrentTimeIndicator: true,
                    firstDayOfWeek: 1,
                    initialSelectedDate: DateTime.now(),
                    minDate: DateTime(DateTime.now().year - 30),

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
                    monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      showAgenda: true,
                      agendaViewHeight: agendaViewHeight,
                    ),
                    scheduleViewSettings: const ScheduleViewSettings(
                      appointmentItemHeight: 60,
                      monthHeaderSettings: MonthHeaderSettings(
                        height: 50,
                      ),
                    ),

                    dataSource: dataSource,
                    key: const ValueKey('calendar_key'),

                    onTap: (CalendarTapDetails details) async {
                      FocusScope.of(context).unfocus();

                      if (details.targetElement ==
                          CalendarElement.calendarCell) {
                        _calendarController.selectedDate = details.date;
                      } else if (details.targetElement ==
                          CalendarElement.appointment) {
                        if (details.appointments == null ||
                            details.appointments!.isEmpty) {
                          return;
                        }
                        final PetAppointment appointment =
                            details.appointments![0] as PetAppointment;

                        final selectedDate = details.date!;

                        await Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => AppointmentEditor.edit(
                              event: appointment,
                              petId: appointment.petId,
                              selectedDate: DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedDate.hour,
                                selectedDate.minute,
                                0,
                                0,
                                0,
                              ),
                              onDelete: (context) {},
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
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

  void onHeaderDateSelect() async {
    await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),

      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: const PickerDialogSettings(
          verticalScrolling: false,
          dialogRoundedCornersRadius: radiusMedium,
          customHeight: 200,
          customWidth: 280,
        ),
        headerSettings: PickerHeaderSettings(
          headerBackgroundColor: Theme.of(context).colorScheme.primary,
          headerIconsColor: Theme.of(context).scaffoldBackgroundColor,
          headerIconsSize: iconSize35,
          previousIcon: Icons.arrow_left,
          nextIcon: Icons.arrow_right,
          headerSelectedIntervalTextStyle: TextStyle(fontSize: 0),
          headerCurrentPageTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerFontSize,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          unselectedMonthsTextColor: Theme.of(
            context,
          ).colorScheme.tertiary,
          selectedMonthBackgroundColor: Theme.of(
            context,
          ).colorScheme.secondary,
          selectedMonthTextColor: Theme.of(context).scaffoldBackgroundColor,
          selectedYearTextColor: Theme.of(context).scaffoldBackgroundColor,
          currentMonthTextColor: Theme.of(context).colorScheme.tertiaryFixed,
          currentYearTextColor: Theme.of(context).colorScheme.tertiaryFixed,
          monthTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: subTextFontSize,
          ),
        ),
        actionBarSettings: PickerActionBarSettings(
          cancelWidget: Text(
            'CANCEL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: buttonTextFontSize,
              letterSpacing: 1.5,
            ),
          ),
          confirmWidget: Text(
            'OK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: buttonTextFontSize,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    ).then((DateTime? pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _calendarController.displayDate = pickedDate;
        });
      }
    });
  }
}
