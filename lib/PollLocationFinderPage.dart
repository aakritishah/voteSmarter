import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class PollLocationFinderPage extends StatefulWidget {
  @override
  _PollLocationFinderPageState createState() => _PollLocationFinderPageState();
}

class _PollLocationFinderPageState extends State<PollLocationFinderPage> {
  List<Map<String, String>> precinctData = [];
  List<String> counties = [
    "Alachua",
    "Baker",
    "Bay",
    "Bradford",
    "Brevard",
    "Broward",
    "Calhoun",
    "Charlotte",
    "Citrus",
    "Clay",
    "Collier",
    "Columbia",
    "DeSoto",
    "Dixie",
    "Duval",
    "Escambia",
    "Flagler",
    "Franklin",
    "Gadsden",
    "Gilchrist",
    "Glades",
    "Gulf",
    "Hamilton",
    "Hardee",
    "Hendry",
    "Hernando",
    "Highlands",
    "Hillsborough",
    "Holmes",
    "Indian River",
    "Jackson",
    "Jefferson",
    "Lafayette",
    "Lake",
    "Lee",
    "Leon",
    "Levy",
    "Liberty",
    "Madison",
    "Manatee",
    "Marion",
    "Martin",
    "Miami-Dade",
    "Monroe",
    "Nassau",
    "Okaloosa",
    "Okeechobee",
    "Orange",
    "Osceola",
    "Palm Beach",
    "Pasco",
    "Pinellas",
    "Polk",
    "Putnam",
    "Santa Rosa",
    "Sarasota",
    "Seminole",
    "St. Johns",
    "St. Lucie",
    "Sumter",
    "Suwannee",
    "Taylor",
    "Union",
    "Volusia",
    "Wakulla",
    "Walton",
    "Washington"
  ];

  String selectedSearch = "";
  String selectedCounty = "";
  String zipcode = "";
  List<Map<String, String>> searchResults = [];

  @override
  void initState() {
    super.initState();
    selectedCounty = counties[0];
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    final csvData = await rootBundle.loadString('assets/precincts_data.csv');
    List<List<dynamic>> csvTable =
        CsvToListConverter().convert(csvData, eol: '\n');
    precinctData = csvTable
        .skip(1)
        .map((row) => {
              'County': row[0].toString(),
              'Precinct Number': row[1].toString(),
              'Location': row[2].toString(),
              'Address': row[3].toString(),
              'Zipcode': row[4].toString(),
            })
        .toList();
  }

  void searchByCounty() {
    setState(() {
      searchResults = precinctData
          .where((entry) => entry['County'] == selectedCounty)
          .toList();
    });
  }

  void searchByZipcode() {
    setState(() {
      searchResults =
          precinctData.where((entry) => entry['Zipcode'] == zipcode).toList();
    });
  }

  void openMaps(String address) async {
    final url = Uri.encodeFull(
        "https://www.google.com/maps/dir/?api=1&destination=$address");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildSearchResults() {
    if (searchResults.isEmpty) {
      return Center(child: Text('No results found'));
    }
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        final fullAddress = '${result['Address']} ${result['Zipcode']}';
        return ListTile(
          title: Text(result['Location']!),
          subtitle: Text(fullAddress),
          onTap: () => openMaps(fullAddress),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Poll Location Finder',
            style: TextStyle(
              fontFamily: 'San Francisco', // Use default system font for iOS
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xffaf170c),
              letterSpacing: 0.5, // Subtle letter spacing
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedSearch = 'county';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedSearch == 'county' ? Colors.grey : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Search by County',
                  style: TextStyle(
                    fontFamily:
                        'San Francisco', // Use default system font for iOS
                    color: Color(0xff2c3afa),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedSearch = 'zipcode';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedSearch == 'zipcode' ? Colors.grey : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Search by Zipcode',
                  style: TextStyle(
                    fontFamily:
                        'San Francisco', // Use default system font for iOS
                    color: Color(0xff2c3afa),
                  ),
                ),
              ),
            ],
          ),
          if (selectedSearch == 'county') ...[
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedCounty,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCounty = newValue!;
                });
              },
              items: counties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily:
                          'San Francisco', // Use default system font for iOS
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: searchByCounty,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontFamily:
                      'San Francisco', // Use default system font for iOS
                ),
              ),
            ),
          ] else if (selectedSearch == 'zipcode') ...[
            SizedBox(height: 16),
            SizedBox(
              width: 100,
              height: 50,
              child: TextField(
                onChanged: (value) {
                  zipcode = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter Zipcode',
                  labelStyle: TextStyle(
                    fontFamily:
                        'San Francisco', // Use default system font for iOS
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: searchByZipcode,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontFamily:
                      'San Francisco', // Use default system font for iOS
                ),
              ),
            ),
          ],
          Expanded(
            child: buildSearchResults(),
          ),
        ],
      ),
    );
  }
}
