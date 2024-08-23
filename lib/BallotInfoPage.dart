import 'package:flutter/material.dart';
import 'Candidate.dart';
import 'Amendment.dart';
import 'AmendmentBioPage.dart';
import 'FormPage.dart'; // Adjust the import based on your file structure

class BallotInfoPage extends StatefulWidget {
  @override
  _BallotInfoPageState createState() => _BallotInfoPageState();
}

class _BallotInfoPageState extends State<BallotInfoPage> {
  final String _selectedState = 'Florida'; // Default to Florida
  List<Candidate> generalCandidates = [];
  List<Amendment> amendCandidates = [];

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    final general = await Candidate.loadCandidates('assets/general.csv');
    final amendments = await Amendment.loadAmendments(
        'assets/amendments.csv'); // Updated to load amendments

    print('Loaded general candidates: ${general.length}');
    print('Loaded amendments: ${amendments.length}');

    setState(() {
      generalCandidates = general;
      amendCandidates = amendments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Ballot Information",
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xffaf170c),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            _buildGeneralElectionSections(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralElectionSections() {
    // Filter general candidates into Presidential and Other Amendments sections
    List<Candidate> presidentialCandidates = generalCandidates
        .where((candidate) =>
            candidate.position == 'President of the United States - 2024')
        .toList();

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$_selectedState General Election',
              style: TextStyle(
                fontFamily: 'San Francisco',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildSection('Presidential Candidates', presidentialCandidates),
          SizedBox(height: 20),
          _buildAmendmentSection(
              'Also on your November ballot:', amendCandidates),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormPage(),
                  ),
                );
              },
              child: Text('Fill Out Form and Generate PDF'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleGeneralElectionButtonPress() {
    // Implement your functionality here
    // For example, navigate to another page or show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('General Election Info'),
        content: Text('Here you can add more information or functionality.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Candidate> candidates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: title == 'Presidential Candidates'
                  ? 20
                  : 24, // Adjust size based on the title
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            return _buildCandidateItem(candidates[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAmendmentSection(String title, List<Amendment> amendments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5, // Adjust as needed for better layout
          ),
          itemCount: amendments.length,
          itemBuilder: (context, index) {
            return _buildAmendmentItem(amendments[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAmendmentItem(Amendment amendment) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          _navigateToAmendmentDetails(amendment);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
          foregroundColor: Colors.black, // Text color
          padding: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Amendment ${amendment.number}:\n${amendment.nickname}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAmendmentDetails(Amendment amendment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmendmentBioPage(amendment: amendment),
      ),
    );
  }

  Widget _buildCandidateItem(Candidate candidate) {
    Color buttonColor =
        Colors.grey.withOpacity(0.8); // Default color with opacity
    if (candidate.party == 'Democratic Party') {
      buttonColor = Color(0xff2c3afa).withOpacity(0.8);
    } else if (candidate.party == 'Republican Party') {
      buttonColor = Color(0xffaf170c).withOpacity(0.8);
    } else if (candidate.party == 'Libertarian Party') {
      buttonColor = Colors.yellow.withOpacity(0.8);
    } else if (candidate.party == 'Green Party') {
      buttonColor = Colors.green.withOpacity(0.8);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 40,
        child: InkWell(
          onTap: () {
            _navigateToCandidateBio(candidate);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    candidate.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    candidate.party,
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCandidateBio(Candidate candidate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateBioPage(candidate: candidate),
      ),
    );
  }
}

class CandidateBioPage extends StatelessWidget {
  final Candidate candidate;

  CandidateBioPage({required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(candidate.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              candidate.party,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 12),
            Text(
              'Running for ${candidate.position}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Bio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              candidate.background,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Key Views',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              candidate.keyViewpoints,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '${candidate.link}',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
