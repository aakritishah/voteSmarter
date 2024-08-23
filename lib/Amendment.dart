import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Amendment {
  final String number;
  final String name;
  final String summary;
  final String vote;
  final String yes;
  final String no;
  final String nickname;

  Amendment({
    required this.number,
    required this.name,
    required this.summary,
    required this.vote,
    required this.yes,
    required this.no,
    required this.nickname,
  });

  // Factory method to create an Amendment instance from CSV data
  factory Amendment.fromCsv(List<String> csvRow) {
    return Amendment(
      number: csvRow[0],
      name: csvRow[1],
      summary: csvRow[2],
      vote: csvRow[3],
      yes: csvRow[4],
      no: csvRow[5],
      nickname: csvRow[6],
    );
  }

  // Method to load amendments from a CSV file
  static Future<List<Amendment>> loadAmendments(String path) async {
    final data = await rootBundle.loadString(path);
    final List<List<String>> csvData = _parseCsv(data);

    // Assuming the first row is the header
    final amendments = <Amendment>[];
    for (var i = 1; i < csvData.length; i++) {
      final amendment = Amendment.fromCsv(csvData[i]);
      amendments.add(amendment);
    }

    return amendments;
  }

  // Method to parse CSV data manually
  static List<List<String>> _parseCsv(String data) {
    final rows = <List<String>>[];
    final lines = LineSplitter.split(data);

    for (var line in lines) {
      final fields = _parseCsvLine(line);
      rows.add(fields);
    }

    return rows;
  }

  // Method to parse a single CSV line
  static List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    var insideQuotes = false;

    for (var char in line.split('')) {
      if (char == '"') {
        insideQuotes = !insideQuotes;
      } else if (char == ',' && !insideQuotes) {
        fields.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    // Add the last field
    if (buffer.isNotEmpty) {
      fields.add(buffer.toString());
    }

    return fields;
  }
}
