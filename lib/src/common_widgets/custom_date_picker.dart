import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const CustomDatePicker({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late int _selectedHour;
  late int _selectedMinute;

  // Generate dates for the picker (e.g., past 5 years to future 5 years)
  // For simplicity, let's do +/- 365 days from initial date for now, or a fixed range
  final List<DateTime> _dates = [];
  late FixedExtentScrollController _dateController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime;
    _selectedHour = widget.initialDateTime.hour;
    _selectedMinute = widget.initialDateTime.minute;

    // Generate dates: Today - 365 days to Today + 365 days
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (int i = -365; i <= 365; i++) {
      _dates.add(today.add(Duration(days: i)));
    }

    // Find initial index
    final initialDateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    int initialDateIndex = _dates.indexWhere((d) => d.isAtSameMomentAs(initialDateOnly));
    if (initialDateIndex == -1) {
      initialDateIndex = _dates.length ~/ 2; // Default to middle if not found
    }

    _dateController = FixedExtentScrollController(initialItem: initialDateIndex);
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    final date = _dates[_dateController.selectedItem];
    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      _selectedHour,
      _selectedMinute,
    );
    widget.onDateTimeChanged(newDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date Column
        Expanded(
          flex: 4,
          child: CupertinoPicker.builder(
            scrollController: _dateController,
            itemExtent: 40,
            useMagnifier: false, // Disable lens effect
            diameterRatio: 1.5, // Flatter appearance
            onSelectedItemChanged: (index) {
              _notifyChanged();
            },
            childCount: _dates.length,
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isToday = _isSameDay(date, DateTime.now());
              final text = isToday
                  ? "Today"
                  : DateFormat('EEE MMM d').format(date);
              
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            },
          ),
        ),
        
        // Hour Column
        Expanded(
          flex: 2,
          child: CupertinoPicker(
            scrollController: _hourController,
            itemExtent: 40,
            useMagnifier: false,
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              _selectedHour = index;
              _notifyChanged();
            },
            children: List.generate(24, (index) {
              return Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            }),
          ),
        ),

        // Minute Column
        Expanded(
          flex: 2,
          child: CupertinoPicker(
            scrollController: _minuteController,
            itemExtent: 40,
            useMagnifier: false,
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              _selectedMinute = index;
              _notifyChanged();
            },
            children: List.generate(60, (index) {
              return Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
