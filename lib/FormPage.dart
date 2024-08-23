import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String? _selectedPresidentialCandidate;
  String? _selectedAmendment1;
  String? _selectedAmendment2;
  String? _selectedAmendment3;
  String? _selectedAmendment4;
  String? _selectedAmendment5;
  String? _selectedAmendment6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Closes the current page
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownFormField(
              label: 'Presidential Candidate',
              value: _selectedPresidentialCandidate,
              items: [
                'Kamala Harris',
                'Donald Trump',
                'Robert F. Kennedy Jr.',
                'Cornel West',
                'Jill Stein',
                'Chase Oliver'
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPresidentialCandidate = value;
                });
              },
            ),
            SizedBox(height: 20),
            _buildDropdownFormField(
              label:
                  'Amendment 1: Election of Members of District School Boards',
              value: _selectedAmendment1,
              items: ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedAmendment1 = value;
                });
              },
            ),
            _buildDropdownFormField(
              label: 'Amendment 2: Fishing and Hunting',
              value: _selectedAmendment2,
              items: ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedAmendment2 = value;
                });
              },
            ),
            _buildDropdownFormField(
              label: 'Amendment 3: Personal Use of Marijuana',
              value: _selectedAmendment3,
              items: ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedAmendment3 = value;
                });
              },
            ),
            _buildDropdownFormField(
              label: 'Amendment 4: Government Interference with Abortion',
              value: _selectedAmendment4,
              items: ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedAmendment4 = value;
                });
              },
            ),
            _buildDropdownFormField(
              label: 'Amendment 5: Value of Certain Homestead Exemptions',
              value: _selectedAmendment5,
              items: ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedAmendment5 = value;
                });
              },
            ),
            _buildDropdownFormField(
              label:
                  'Amendment 6: Campaigns of Candidates for Statewide Office',
              value: _selectedAmendment6,
              items: ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedAmendment6 = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAndSavePdf,
              child: Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _generateAndSavePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Presidential Candidate: $_selectedPresidentialCandidate',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
              pw.SizedBox(height: 20), // Adjust spacing
              pw.Text(
                'Amendment 1: Election of Members of District School Boards: $_selectedAmendment1',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Amendment 2: Fishing and Hunting: $_selectedAmendment2',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Amendment 3: Personal Use of Marijuana: $_selectedAmendment3',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Amendment 4: Government Interference with Abortion: $_selectedAmendment4',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Amendment 5: Value of Certain Homestead Exemptions: $_selectedAmendment5',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Amendment 6: Campaigns of Candidates for Statewide Office: $_selectedAmendment6',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold, // Make text bold
                ),
              ),
            ],
          ));
        },
      ),
    );

    if (kIsWeb) {
      // Handle file saving for the web if needed
      // For example, using packages like flutter_web_plugins for web file downloads
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/form.pdf');
      await file.writeAsBytes(await pdf.save());

      // Open the PDF
      OpenFile.open(file.path);
    }
  }
}
