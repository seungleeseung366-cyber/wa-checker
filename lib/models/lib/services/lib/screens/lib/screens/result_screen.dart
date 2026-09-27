import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scan_result.dart';
import '../services/detector_service.dart';

class ResultScreen extends StatelessWidget {
  final String number;
  const ResultScreen({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final result = DetectorService.scan(number);

    Color mainColor;
    IconData icon;
    switch (result.level) {
      case ThreatLevel.safe:
        mainColor = const Color(0xFF00E676);
        icon = Icons.verified_user_rounded;
        break;
      case ThreatLevel.warning:
        mainColor = const Color(0xFFFFC107);
        icon = Icons.warning_amber_rounded;
        break;
      case ThreatLevel.danger:
        mainColor = const Color(0xFFFF1744);
        icon = Icons.gpp_bad_rounded;
        break;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              mainColor.withOpacity(0.15),
              const Color(0xFF0A0E27),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text('HASIL SCAN',
                        style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      mainColor.withOpacity(0.25),
                      mainColor.withOpacity(0.05)
                    ]),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: mainColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: mainColor.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor.withOpacity(0.2),
                          border: Border.all(color: mainColor, width: 2),
                        ),
                        child: Icon(icon, size: 60, color: mainColor),
                      ),
                      const SizedBox(height: 20),
                      Text(result.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.orbitron(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                              letterSpacing: 1.5)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('+${result.number}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _sectionTitle('📋 ALASAN', mainColor),
                const SizedBox(height: 12),
                ...result.reasons.asMap().entries.map((e) =>
                    _listItem(e.value, mainColor, e.key + 1)),
                const SizedBox(height: 24),
                _sectionTitle('💡 SOLUSI & REKOMENDASI', mainColor),
                const SizedBox(height: 12),
                ...result.solutions.asMap().entries.map((e) =>
                    _listItem(e.value, mainColor, e.key + 1, isSolution: true)),
                const SizedBox(height: 30),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh, color: Color(0xFF00E5FF)),
                  label: const Text('SCAN NOMOR LAIN',
                      style: TextStyle(
                          color: Color(0xFF00E5FF), letterSpacing: 1.5)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                        color: Color(0xFF00E5FF), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: color),
        const SizedBox(width: 10),
        Text(text,
            style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5)),
      ],
    );
  }

  Widget _listItem(String text, Color color, int index,
      {bool isSolution = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
              border: Border.all(color: color),
            ),
            child: isSolution
                ? Icon(Icons.check, size: 14, color: color)
                : Text('$index',
                    style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
