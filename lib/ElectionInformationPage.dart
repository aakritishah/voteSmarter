import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class ElectionInformationPage extends StatelessWidget {
  final String _selectedState = 'Florida'; // Default to Florida

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 64.0),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: _buildCountdownTimer(
                DateTime(2024, 11, 5),
                'General',
                Color(0xff2c3afa),
              ),
            ),
            SizedBox(height: 40),
            _buildSection('$_selectedState General Election', [
              _buildInfoItem(context, 'General Election', 'Tue Nov 5, 2024',
                  DateTime(2024, 11, 5)),
              _buildInfoItem(context, 'General Voter Registration',
                  'Mon Oct 7, 2024', DateTime(2024, 10, 7)),
              _buildInfoItem(context, 'General Absentee Ballot Request',
                  'Thu Oct 24, 2024 @ 5:00 PM', DateTime(2024, 10, 24, 17, 0)),
              _buildInfoItem(context, 'General Absentee Ballot Return',
                  'Tue Nov 5, 2024 @ 7:00 PM', DateTime(2024, 11, 5, 19, 0)),
            ]),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(DateTime endTime, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CountdownTimer(
          endTime: endTime.millisecondsSinceEpoch,
          textStyle: TextStyle(fontSize: 30, color: color), // Reduced font size
        ),
        SizedBox(height: 5),
        Text('Days Until $label Election', style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String title, String value, DateTime eventDate) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffaf170c),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _showAddToCalendarDialog(context, title, eventDate);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddToCalendarDialog(
      BuildContext context, String title, DateTime eventDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add to Calendar"),
          content: Text("Do you want to add this date to your calendar?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                Navigator.of(context).pop();
                _addToCalendar(title, eventDate);
              },
            ),
          ],
        );
      },
    );
  }

  void _addToCalendar(String title, DateTime date) {
    final Event event = Event(
      title: title,
      startDate: date,
      endDate: date.add(Duration(hours: 1)), // Example: Event lasts 1 hour
    );
    Add2Calendar.addEvent2Cal(event);
  }
}
