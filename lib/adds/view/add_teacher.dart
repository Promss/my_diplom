import 'package:flutter/material.dart';

class AddTeacher extends StatefulWidget {
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final Map<String, bool> _selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  final Map<String, Map<String, TimeOfDay?>> _timeRanges = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Schedule'),
      ),
      body: ListView(
        children: _selectedDays.keys.map((day) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(day),
                value: _selectedDays[day],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedDays[day] = value ?? false;
                    if (!value!) {
                      _timeRanges.remove(day);
                    }
                  });
                },
              ),
              if (_selectedDays[day]!)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Column(
                    children: [
                      _buildTimeRangeSelector(day),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle save action here
          print('Selected Days and Times:');
          _selectedDays.forEach((day, isSelected) {
            if (isSelected) {
              print(
                  '$day: ${_timeRanges[day]?['startTime']?.format(context) ?? 'Not set'} - ${_timeRanges[day]?['endTime']?.format(context) ?? 'Not set'}');
            }
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildTimeRangeSelector(String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimeButton(day, true),
            ),
            Text(' - '),
            Expanded(
              child: _buildTimeButton(day, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeButton(String day, bool isStartTime) {
    String label = isStartTime ? 'Start Time' : 'End Time';
    TimeOfDay? time = _timeRanges[day]?[isStartTime ? 'startTime' : 'endTime'];

    return TextButton(
      onPressed: () => _selectTime(context, day, isStartTime),
      child: Text(time != null ? time.format(context) : label),
    );
  }

  Future<void> _selectTime(
      BuildContext context, String day, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _timeRanges[day]?[isStart ? 'startTime' : 'endTime'] ??
          TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeRanges[day] ??= {};
        _timeRanges[day]![isStart ? 'startTime' : 'endTime'] = picked;
      });
    }
  }
}
