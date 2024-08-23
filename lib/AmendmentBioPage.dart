import 'package:flutter/material.dart';
import 'Amendment.dart';

class AmendmentBioPage extends StatelessWidget {
  final Amendment amendment;

  AmendmentBioPage({required this.amendment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amendment ${amendment.number}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${amendment.name}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Summary:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              amendment.vote,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Your Vote:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              amendment.summary,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'A Yes vote ${amendment.yes}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'A No vote ${amendment.no}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
