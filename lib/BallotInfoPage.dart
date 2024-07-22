import 'package:flutter/material.dart';
import 'Candidate.dart';

class BallotInfoPage extends StatefulWidget {
  @override
  _BallotInfoPageState createState() => _BallotInfoPageState();
}

class _BallotInfoPageState extends State<BallotInfoPage> {
  final String _selectedState = 'Florida'; // Default to Florida
  List<Candidate> primaryCandidates = [];
  List<Candidate> generalCandidates = [];

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    final primary = await Candidate.loadCandidates('assets/primary.csv');
    final general = await Candidate.loadCandidates('assets/general.csv');

    setState(() {
      primaryCandidates = primary;
      generalCandidates = general;
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
              fontFamily: 'San Francisco', // Use default system font for iOS
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xffaf170c),
              letterSpacing: 0.5, // Subtle letter spacing
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
            _buildPrimarySections(),
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
    List<Candidate> otherAmendmentsCandidates = generalCandidates
        .where((candidate) =>
            candidate.position != 'President of the United States - 2024')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            '$_selectedState General Election',
            style: TextStyle(
              fontFamily: 'San Francisco', // Use default system font for iOS
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5, // Subtle letter spacing
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildSection('Presidential Candidates', presidentialCandidates,
            isPrimary: false),
        SizedBox(height: 20),
        _buildSection('Other Amendments', otherAmendmentsCandidates,
            isPrimary: false),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPrimarySections() {
    // Filter primary candidates into Senate and House sections
    List<Candidate> senateCandidates = primaryCandidates
        .where((candidate) => candidate.position == 'U.S. Senate')
        .toList();
    List<Candidate> houseCandidates = primaryCandidates
        .where((candidate) => candidate.position == 'U.S. Representative')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            '$_selectedState State Primary',
            style: TextStyle(
              fontFamily: 'San Francisco', // Use default system font for iOS
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 0.5, // Subtle letter spacing
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildSection('Senate', senateCandidates),
        SizedBox(height: 20),
        _buildSection('House of Representatives', houseCandidates),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSection(String title, List<Candidate> candidates,
      {bool isPrimary = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'San Francisco', // Use default system font for iOS
              fontSize:
                  isPrimary ? 20 : 24, // Adjust font size based on section type
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.black : Colors.black87,
              letterSpacing: 0.5, // Subtle letter spacing
            ),
          ),
        ),
        SizedBox(height: 10),
        // Use SliverGridDelegateWithMaxCrossAxisExtent for rectangular items
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // Disables scrolling
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // Maximum width of the items
            childAspectRatio: 2 / 1, // Aspect ratio for width/height
            crossAxisSpacing: 10, // Horizontal space between items
            mainAxisSpacing: 10, // Vertical space between items
          ),
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            return _buildCandidateItem(candidates[index]);
          },
        ),
      ],
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
        height: 40, // Further reduced height for the buttons
        child: InkWell(
          onTap: () {
            _navigateToCandidateBio(candidate);
          },
          child: Center(
            // Center the text within the button
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  Text(
                    candidate.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // Center text horizontally
                  ),
                  Text(
                    candidate.party,
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center, // Center text horizontally
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
              "Running for ${candidate.position}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              "Bio",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              candidate.background,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              "Key Views",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              candidate.keyViewpoints,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              "${candidate.link}",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
