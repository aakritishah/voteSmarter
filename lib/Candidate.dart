import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class Candidate {
  final String race;
  final String position;
  final String name;
  final String party;
  final String background;
  final String keyViewpoints;
  final String link;

  Candidate({
    required this.race,
    required this.position,
    required this.name,
    required this.party,
    required this.background,
    required this.keyViewpoints,
    required this.link,
  });

  static Future<List<Candidate>> loadCandidates(String filePath) async {
    try {
      final data = await rootBundle.loadString(filePath);
      List<List<dynamic>> csvData =
          CsvToListConverter().convert(data, eol: '\n');
      // Assuming the CSV has a header row, so skipping it
      csvData.removeAt(0);

      return csvData.map((row) {
        return Candidate(
          race: row[0].toString(),
          position: row[1].toString(),
          name: row[2].toString(),
          party: row[3].toString(),
          background: row[4].toString(),
          keyViewpoints: row[5].toString(),
          link: row[6].toString(),
        );
      }).toList();
    } catch (e) {
      print('Error loading candidates: $e');
      return [];
    }
  }
}
