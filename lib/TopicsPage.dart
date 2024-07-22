import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MaterialApp(home: TopicsPage()));
}

class TopicsPage extends StatefulWidget {
  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final List<String> topics = [
    'Climate Change',
    'Gun Control',
    'Healthcare Reform',
    'Immigration Policy',
    'Abortion Rights',
    'Education Funding',
    'Minimum Wage',
    'Tax Reform',
    'Criminal Justice Reform',
    'Foreign Policy',
    'Voting Rights',
    'LGBTQIA+ Rights',
    'Economic Inequality',
    'Police Reform',
    'Drug Legalization'
  ];

  List<String> filteredTopics;
  TextEditingController _searchController = TextEditingController();

  _TopicsPageState() : filteredTopics = [];

  @override
  void initState() {
    super.initState();
    filteredTopics = topics;
  }

  void filterTopics(String query) {
    setState(() {
      filteredTopics = topics
          .where((topic) => topic.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    _searchController.clear();
    filterTopics('');
  }

  void onTopicPressed(String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateStancesPage(topic: topic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Topics of Interest',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select topics below to learn where different candidates stand on important issues regarding the 2024 United States Presidential Election.',
              style: TextStyle(
                fontFamily: 'San Francisco', // Use default system font for iOS
                fontSize: 14,
                color: Colors.black,
                letterSpacing: 0.5, // Subtle letter spacing
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Topics',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 12.0), // Adjust vertical padding for height
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
              ),
              onChanged: filterTopics,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set crossAxisCount to 2 for 2 columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio:
                      2, // Set child aspect ratio to be more rectangular
                ),
                itemCount: filteredTopics.length,
                itemBuilder: (context, index) {
                  final topic = filteredTopics[index];
                  return ElevatedButton(
                    onPressed: () => onTopicPressed(topic),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.grey[200]), // Light gray background
                      foregroundColor: MaterialStateProperty.all(
                          Colors.black), // Black text color
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all(
                          Size(double.infinity, 40)), // Set fixed height to 40
                    ),
                    child: Center(
                      child: Text(
                        topic,
                        style: TextStyle(
                          fontFamily:
                              'San Francisco', // Use default system font for iOS
                          fontSize: 15, // Smaller font size
                        ),
                        textAlign: TextAlign.center, // Center text
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CandidateStancesPage extends StatefulWidget {
  final String topic;

  CandidateStancesPage({required this.topic});

  @override
  _CandidateStancesPageState createState() => _CandidateStancesPageState();
}

class _CandidateStancesPageState extends State<CandidateStancesPage> {
  List<Map<String, String>> stances = [];

  @override
  void initState() {
    super.initState();
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    final csvData = await rootBundle.loadString('assets/stances.csv');
    List<List<dynamic>> csvTable =
        CsvToListConverter().convert(csvData, eol: '\n');

    setState(() {
      stances = csvTable
          .skip(1)
          .map((row) => {
                'candidate': row[0].toString(),
                'topic': row[1].toString(),
                'stance': row[2].toString(),
                'party': row[3].toString(),
              })
          .where((row) => row['topic'] == widget.topic)
          .toList();
    });
  }

  Color getPartyColor(String party) {
    switch (party.toLowerCase()) {
      case 'democratic':
        return Colors.blue[100]!;
      case 'republican':
        return Colors.red[100]!;
      case 'libertarian':
        return Colors.yellow[100]!;
      case 'independent':
        return Colors.grey[400]!;
      case 'green':
        return Colors.green[100]!;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stances on ${widget.topic}',
          style: TextStyle(
            fontFamily: 'San Francisco', // Use default system font for iOS
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: stances.length,
        itemBuilder: (context, index) {
          final stance = stances[index];
          final partyColor = getPartyColor(stance['party']!);

          return Card(
            color: partyColor
                .withOpacity(0.7), // Lighter color for card background
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${stance['candidate']} (${stance['party']})',
                    style: TextStyle(
                      fontFamily:
                          'San Francisco', // Use default system font for iOS
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text color
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    stance['stance']!,
                    style: TextStyle(
                      fontFamily:
                          'San Francisco', // Use default system font for iOS
                      fontSize: 16,
                      color: Colors.black, // Black text color
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
