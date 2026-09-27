import '../models/scan_result.dart';

class DetectorService {
  static const Map<String, String> _countryCodes = {
    '62': 'Indonesia',
    '60': 'Malaysia',
    '65': 'Singapura',
    '66': 'Thailand',
    '63': 'Filipina',
    '84': 'Vietnam',
    '1': 'USA/Kanada',
    '44': 'UK',
    '91': 'India',
    '86': 'China',
    '234': 'Nigeria',
    '92': 'Pakistan',
    '7': 'Rusia',
  };

  static const List<String> _highRiskPrefix = ['900', '901', '902', '1900'];

  static ScanResult scan(String rawInput) {
    final reasons = <String>[];
    final solutions = <String>[];
    String number = rawInput.replaceAll(RegExp(r'[^0-9+]'), '');

    if (number.startsWith('+')) number = number.substring(1);
    if (number.startsWith('0')) number = '62${number.substring(1)}';
    if (number.startsWith('8')) number = '62$number';

    if (number.isEmpty || number.length < 8) {
      return ScanResult(
        level: ThreatLevel.danger,
        title: '❌ Nomor Tidak Valid',
        reasons: ['Format nomor terlalu pendek / kosong.'],
        solutions: ['Periksa kembali nomor yang kamu masukkan.'],
        number: rawInput,
      );
    }

    if (number.length > 15) {
      reasons.add('Panjang nomor melebihi standar internasional (max 15 digit).');
    }

    String country = 'Tidak diketahui';
    String matchedCode = '';
    final codes = _countryCodes.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final code in codes) {
      if (number.startsWith(code)) {
        country = _countryCodes[code]!;
        matchedCode = code;
        break;
      }
    }

    if (RegExp(r'(\d)\1{4,}').hasMatch(number)) {
      reasons.add('Mengandung angka berulang (pola spam).');
      solutions.add('Jangan transfer uang / klik link dari nomor ini.');
    }

    if (number.contains('123456') || number.contains('654321')) {
      reasons.add('Mengandung pola urut mencurigakan.');
    }

    const highRiskCountries = ['234', '92', '7'];
    if (highRiskCountries.contains(matchedCode)) {
      reasons.add('Berasal dari region dengan laporan scam tinggi ($country).');
      solutions.add('Verifikasi identitas pengirim lewat video call.');
    }

    for (final p in _highRiskPrefix) {
      if (number.contains(p)) {
        reasons.add('Mengandung prefix premium/rate tinggi ($p).');
      }
    }

    ThreatLevel level;
    String title;

    if (reasons.isEmpty) {
      level = ThreatLevel.safe;
      title = '✅ Nomor mu AMAN';
      reasons.add('Format nomor valid.');
      reasons.add('Terdeteksi berasal dari: $country.');
      reasons.add('Tidak ada pola spam/scam yang terdeteksi.');
      solutions.add('Tetap waspada terhadap permintaan mencurigakan.');
      solutions.add('Jangan pernah bagikan kode OTP ke siapa pun.');
      solutions.add('Blokir jika menerima pesan spam.');
    } else if (reasons.length <= 1) {
      level = ThreatLevel.warning;
      title = '⚠️ Nomor mu PERLU DIPERIKSA';
      solutions.add('Konfirmasi ke pengirim sebelum merespon.');
      solutions.add('Aktifkan verifikasi 2 langkah di WhatsApp.');
      solutions.add('Laporkan ke WhatsApp jika terindikasi spam.');
    } else {
      level = ThreatLevel.danger;
      title = '🚨 Nomor mu BAHAYA';
      solutions.add('JANGAN transfer uang atau bagikan data pribadi.');
      solutions.add('Blokir & laporkan nomor ini di WhatsApp.');
      solutions.add('Laporkan ke https://aduannomor.id jika ada penipuan.');
      solutions.add('Aktifkan WhatsApp Two-Step Verification.');
    }

    return ScanResult(
      level: level,
      title: title,
      reasons: reasons,
      solutions: solutions,
      number: number,
    );
  }
}
