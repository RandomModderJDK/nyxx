import 'package:nyxx/nyxx.dart';
import 'package:test/test.dart';

void main() {
  group('Snowflake', () {
    test('zero has correct value', () {
      expect(Snowflake.zero.value.toInt(), isZero);
      expect(Snowflake.zero.isZero, isTrue);
    });

    test('structure is parsed correctly', () {
      var snowflake = Snowflake.parse("175928847299117063");

      expect(snowflake.increment.toInt(), equals(7));
      expect(snowflake.processId.toInt(), equals(0));
      expect(snowflake.workerId.toInt(), equals(1));
      expect(snowflake.millisecondsSinceEpoch.toInt(), equals(41944705796));
    });

    test('timestamp is parsed correctly', () {
      var snowflake = Snowflake.parse("175928847299117063");

      expect(snowflake.timestamp, DateTime.utc(2016, 04, 30, 11, 18, 25, 796));
    });

    test('equality', () {
      final snowflake = Snowflake(0);

      expect(snowflake, equals(Snowflake.zero));
      expect(snowflake.hashCode, equals(Snowflake.zero.hashCode));
      expect(snowflake.compareTo(Snowflake.zero), isZero);
    });

    test('parse', () {
      expect(Snowflake.parse('175928847299117063'), equals(Snowflake(175928847299117063)));
    });

    // Indirectly tests fromDateTime
    test('now', () {
      final snowflake = Snowflake.now();

      expect(snowflake.increment.toInt(), isZero);
      expect(snowflake.processId.toInt(), isZero);
      expect(snowflake.workerId.toInt(), isZero);

      expect(snowflake.timestamp.millisecondsSinceEpoch, closeTo(DateTime.now().millisecondsSinceEpoch, 500));
    });

    test('isBefore', () {
      final snowflake1 = Snowflake.fromDateTime(DateTime(2020));
      final snowflake2 = Snowflake.fromDateTime(DateTime(2019));

      expect(snowflake2.isBefore(snowflake1), isTrue);
      expect(snowflake1.isBefore(snowflake2), isFalse);
    });

    test('isAfter', () {
      final snowflake1 = Snowflake.fromDateTime(DateTime(2020));
      final snowflake2 = Snowflake.fromDateTime(DateTime(2019));

      expect(snowflake2.isAfter(snowflake1), isFalse);
      expect(snowflake1.isAfter(snowflake2), isTrue);
    });

    test('isAtSameMomentAs', () {
      final snowflake1 = Snowflake.fromDateTime(DateTime(2020));
      final snowflake2 = Snowflake.fromDateTime(DateTime(2019));
      final snowflake3 = Snowflake.fromDateTime(DateTime(2020));

      expect(snowflake2.isAtSameMomentAs(snowflake1), isFalse);
      expect(snowflake1.isAtSameMomentAs(snowflake2), isFalse);
      expect(snowflake3.isAtSameMomentAs(snowflake1), isTrue);
      expect(snowflake2.isAtSameMomentAs(snowflake3), isFalse);
    });

    test('operator +', () {
      final snowflake = Snowflake.fromDateTime(DateTime(2022, 1, 1));

      expect(snowflake + const Duration(days: 1), equals(Snowflake.fromDateTime(DateTime(2022, 1, 2))));
    });

    test('operator -', () {
      final snowflake = Snowflake.fromDateTime(DateTime(2022, 1, 2));

      expect(snowflake - const Duration(days: 1), equals(Snowflake.fromDateTime(DateTime(2022, 1, 1))));
    });

    test('compareTo', () {
      final snowflake1 = Snowflake.fromDateTime(DateTime(2019));
      final snowflake2 = Snowflake.fromDateTime(DateTime(2018));
      final snowflake3 = Snowflake.fromDateTime(DateTime(2017));

      expect([snowflake3, snowflake1, snowflake2, snowflake1]..sort(), equals([snowflake3, snowflake2, snowflake1, snowflake1]));
    });
  });
}
