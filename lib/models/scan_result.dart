enum ThreatLevel { safe, warning, danger }

class ScanResult {
  final ThreatLevel level;
  final String title;
  final List<String> reasons;
  final List<String> solutions;
  final String number;

  ScanResult({
    required this.level,
    required this.title,
    required this.reasons,
    required this.solutions,
    required this.number,
  });
}
