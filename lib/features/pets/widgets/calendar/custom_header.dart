import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomHeader extends StatelessWidget {
  final String headerText;
  final CalendarController controller;
  final VoidCallback onViewChanged;
  const CustomHeader({
    super.key,
    required this.headerText,
    required this.controller,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.calendar_month;
    if (controller.view == CalendarView.month) {
      icon = Icons.calendar_month;
    } else if (controller.view == CalendarView.week) {
      icon = Icons.calendar_view_week;
    } else if (controller.view == CalendarView.day) {
      icon = Icons.calendar_today;
    } else if (controller.view == CalendarView.schedule) {
      icon = Icons.schedule;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerText.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
              letterSpacing: 1.2,
              fontSize: 18,
            ),
          ),

          PopupMenuButton<CalendarView>(
            initialValue: controller.view,

            onSelected: (CalendarView view) {
              controller.view = view;
              onViewChanged();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: CalendarView.month,
                child: Text(
                  'Month',
                  style: TextStyle(
                    color: controller.view == CalendarView.month
                        ? Theme.of(context).colorScheme.tertiaryFixed
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: controller.view == CalendarView.month
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),

              PopupMenuItem(
                value: CalendarView.week,
                child: Text(
                  'Week',
                  style: TextStyle(
                    color: controller.view == CalendarView.week
                        ? Theme.of(context).colorScheme.tertiaryFixed
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: controller.view == CalendarView.week
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),

              PopupMenuItem(
                value: CalendarView.day,
                child: Text(
                  'Day',
                  style: TextStyle(
                    color: controller.view == CalendarView.day
                        ? Theme.of(context).colorScheme.tertiaryFixed
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: controller.view == CalendarView.day
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),

              PopupMenuItem(
                value: CalendarView.schedule,
                child: Text(
                  'Schedule',
                  style: TextStyle(
                    color: controller.view == CalendarView.schedule
                        ? Theme.of(context).colorScheme.tertiaryFixed
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: controller.view == CalendarView.schedule
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                // Light overlay to contrast against the primary header
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 25,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
