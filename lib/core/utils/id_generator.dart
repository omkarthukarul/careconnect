import 'dart:math';

class IdGenerator {
  IdGenerator._();

  static final Random _random = Random();

  /// Generates a standardized Maharashtra Health Patient ID
  /// Format: MH-<DIST>-<YEAR>-<4-DIGIT>
  static String generatePatientId([String districtCode = 'PUN']) {
    final cleanCode = districtCode.length >= 3 
        ? districtCode.substring(0, 3).toUpperCase() 
        : 'MAH';
    final year = DateTime.now().year;
    final seq = _random.nextInt(9000) + 1000;
    return 'MH-$cleanCode-$year-$seq';
  }

  /// Generates a standardized Referral ID
  /// Format: REF-MH-<YEAR>-<5-DIGIT>
  static String generateReferralId() {
    final year = DateTime.now().year;
    final seq = _random.nextInt(90000) + 10000;
    return 'REF-MH-$year-$seq';
  }

  /// Generates a Bed Reservation ID
  /// Format: RES-ICU-<4-DIGIT>
  static String generateReservationId(String wardType) {
    final cleanWard = wardType.toUpperCase().replaceAll(' ', '');
    final seq = _random.nextInt(900) + 100;
    return 'BED-$cleanWard-$seq';
  }
}
