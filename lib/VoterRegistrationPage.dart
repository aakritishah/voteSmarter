import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';

class VoterRegistrationPage extends StatefulWidget {
  @override
  _VoterRegistrationPageState createState() => _VoterRegistrationPageState();
}

class _VoterRegistrationPageState extends State<VoterRegistrationPage> {
  String _selectedState = '';
  Map<String, Map<String, String>> _stateLinks = {};

  @override
  void initState() {
    super.initState();
    _loadStateLinks();
  }

  Future<void> _loadStateLinks() async {
    String csvData = await rootBundle.loadString('assets/state_links.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

    csvTable.forEach((row) {
      if (row[0] != 'state') {
        _stateLinks[row[0]] = {
          'registration': row[1],
          'checkRegistration': row[2],
        };
      }
    });

    setState(() {});
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 64.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Registration Instructions",
                  style: TextStyle(
                    fontFamily:
                        'San Francisco', // This will use the default system font on iOS
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffaf170c),
                    letterSpacing:
                        0.5, // Add subtle letter spacing for a refined look
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: DropdownButton<String>(
                  hint: Text(
                    'Select State',
                    style: TextStyle(color: Color(0xffaf170c)),
                  ),
                  value: _selectedState.isEmpty ? null : _selectedState,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedState = newValue!;
                    });
                  },
                  items: _stateLinks.keys.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedState.isNotEmpty &&
                  _stateLinks.containsKey(_selectedState))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegistrationStepView(
                      stepNumber: "1",
                      stepTitle: "Check Eligibility",
                      stepDescription:
                          "Make sure you are eligible to vote in your state. Requirements may vary by state but are most likely to include:\n• Must be 18\n• Must be a citizen of the United States\n• Must reside in the state in which you are voting",
                    ),
                    RegistrationStepView(
                      stepNumber: "2",
                      stepTitle: "Gather Documents",
                      stepDescription:
                          "Collect necessary identification documents:\n• Driver's License or Passport\n• Last 4 digits of your Social Security Number",
                    ),
                    RegistrationStepView(
                      stepNumber: "3",
                      stepTitle: "Complete Registration Form",
                      stepDescription:
                          "Fill out a voter registration form. This can be done by clicking the button below ↓",
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xffaf170c),
                          minimumSize: Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _launchURL(
                              _stateLinks[_selectedState]!['registration']!);
                        },
                        child: Text(
                          "Registration",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RegistrationStepView(
                      stepNumber: "4",
                      stepTitle: "Submit Registration",
                      stepDescription:
                          "Submit your completed registration form by the deadline. Your registration deadlines are:\n• Monday July 22, 2024 for the Primary Election\n• Monday October 7, 2024 for the General Election",
                    ),
                    RegistrationStepView(
                      stepNumber: "5",
                      stepTitle: "Verify Registration",
                      stepDescription:
                          "Check your voter registration status to ensure it was processed successfully using the button below ↓",
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xffaf170c),
                          minimumSize: Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _launchURL(_stateLinks[_selectedState]![
                              'checkRegistration']!);
                        },
                        child: Text(
                          "Check Registration",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationStepView extends StatelessWidget {
  final String stepNumber;
  final String stepTitle;
  final String stepDescription;

  RegistrationStepView({
    required this.stepNumber,
    required this.stepTitle,
    required this.stepDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step $stepNumber: $stepTitle",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          stepDescription,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
