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
                DateTime(2024, 8, 20),
                'Primary',
                Color(0xffaf170c),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: _buildCountdownTimer(
                DateTime(2024, 11, 5),
                'General',
                Color(0xff2c3afa),
              ),
            ),
            SizedBox(height: 40),
            _buildSection('$_selectedState State Primary', [
              _buildInfoItem('Primary Election', 'Tue Aug 20, 2024'),
              _buildInfoItem('Primary Voter Registration', 'Mon Jul 22, 2024'),
              _buildInfoItem('Primary Absentee Ballot Request',
                  'Thu Aug 8, 2024 @ 5:00 PM'),
              _buildInfoItem('Primary Absentee Ballot Return',
                  'Tue Aug 20, 2024 @ 7:00 PM'),
            ]),
            SizedBox(height: 20),
            _buildSection('$_selectedState General Election', [
              _buildInfoItem('General Election', 'Tue Nov 5, 2024'),
              _buildInfoItem('General Voter Registration', 'Mon Oct 7, 2024'),
              _buildInfoItem('General Absentee Ballot Request',
                  'Thu Oct 24, 2024 @ 5:00 PM'),
              _buildInfoItem('General Absentee Ballot Return',
                  'Tue Nov 5, 2024 @ 7:00 PM'),
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

  Widget _buildInfoItem(String title, String value) {
    return Container(
      height: 74, // Increased height by 1 pixel
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
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffaf170c),
            ),
          ),
        ],
      ),
    );
  }
}
