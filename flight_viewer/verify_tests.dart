import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('Verify test files exist', () {
    // Check that test files exist
    expect(File('test/widget_test.dart').existsSync(), isTrue);
    expect(File('test/backend_integration_test.dart').existsSync(), isTrue);
    expect(Directory('test/unit').existsSync(), isTrue);
    expect(Directory('test/widget').existsSync(), isTrue);
    expect(Directory('test/integration').existsSync(), isTrue);
  });
  
  test('Verify test structure', () {
    // Check that we have the expected test structure
    expect(Directory('test/unit/models').existsSync(), isTrue);
    expect(Directory('test/unit/services').existsSync(), isTrue);
    expect(Directory('test/unit/blocs').existsSync(), isTrue);
    expect(Directory('test/widget').existsSync(), isTrue);
    expect(Directory('test/integration').existsSync(), isTrue);
  });
}