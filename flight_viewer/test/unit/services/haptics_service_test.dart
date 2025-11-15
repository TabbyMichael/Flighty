import 'package:flutter_test/flutter_test.dart';
import 'package:flight_viewer/services/haptics_service.dart';

void main() {
  group('HapticsService', () {
    late HapticsService hapticsService;

    setUp(() {
      hapticsService = HapticsService();
    });

    test('can be instantiated', () {
      expect(hapticsService, isNotNull);
    });

    test('selection method can be called without error', () {
      // This test just verifies the method can be called without throwing an exception
      expect(() => hapticsService.selection(), returnsNormally);
    });

    test('success method can be called without error', () {
      // This test just verifies the method can be called without throwing an exception
      expect(() => hapticsService.success(), returnsNormally);
    });

    test('error method can be called without error', () {
      // This test just verifies the method can be called without throwing an exception
      expect(() => hapticsService.error(), returnsNormally);
    });

    test('lightImpact method can be called without error', () {
      // This test just verifies the method can be called without throwing an exception
      expect(() => hapticsService.lightImpact(), returnsNormally);
    });

    test('mediumImpact method can be called without error', () {
      // This test just verifies the method can be called without throwing an exception
      expect(() => hapticsService.mediumImpact(), returnsNormally);
    });

    test('heavyImpact method can be called without error', () {
      // This test just verifies the method can be called without throwing an exception
      expect(() => hapticsService.heavyImpact(), returnsNormally);
    });
  });
}