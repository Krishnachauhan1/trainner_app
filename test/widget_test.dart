import 'package:flutter_test/flutter_test.dart';
import 'package:trainner_app/utils/seed_data.dart';

void main() {
  test('seed trainer name', () {
    expect(SeedData.trainerName, contains('Aarav'));
  });
}
