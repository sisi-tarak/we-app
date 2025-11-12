import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime? selectedDateTime;
  final bool isASAP;
  final Function(DateTime?) onDateTimeSelected;
  final Function(bool) onASAPChanged;

  const DateTimePickerWidget({
    Key? key,
    this.selectedDateTime,
    required this.isASAP,
    required this.onDateTimeSelected,
    required this.onASAPChanged,
  }) : super(key: key);

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'When do you need this done?',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // ASAP Option
          GestureDetector(
            onTap: () {
              widget.onASAPChanged(true);
              widget.onDateTimeSelected(null);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: widget.isASAP
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                    : AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: widget.isASAP
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: widget.isASAP ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: widget.isASAP
                        ? 'radio_button_checked'
                        : 'radio_button_unchecked',
                    color: widget.isASAP
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ASAP',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: widget.isASAP
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'I need this done as soon as possible',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: widget.isASAP
                              ? AppTheme
                                  .lightTheme.colorScheme.onPrimaryContainer
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Specific Date/Time Option
          GestureDetector(
            onTap: () {
              widget.onASAPChanged(false);
              _selectDateTime();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: !widget.isASAP
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                    : AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: !widget.isASAP
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: !widget.isASAP ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: !widget.isASAP
                        ? 'radio_button_checked'
                        : 'radio_button_unchecked',
                    color: !widget.isASAP
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Specific Date & Time',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: !widget.isASAP
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        if (widget.selectedDateTime != null &&
                            !widget.isASAP) ...[
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatDateTime(widget.selectedDateTime!),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ] else if (!widget.isASAP) ...[
                          Text(
                            'Tap to select date and time',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!widget.isASAP)
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDateTime ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && mounted) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: widget.selectedDateTime != null
            ? TimeOfDay.fromDateTime(widget.selectedDateTime!)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: AppTheme.lightTheme.colorScheme,
            ),
            child: child!,
          );
        },
      );

      if (selectedTime != null && mounted) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        widget.onDateTimeSelected(finalDateTime);
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final String month = months[dateTime.month - 1];
    final String day = dateTime.day.toString();
    final String year = dateTime.year.toString();

    final String hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString()
        : (dateTime.hour == 0 ? 12 : dateTime.hour).toString();
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year at $hour:$minute $period';
  }
}
