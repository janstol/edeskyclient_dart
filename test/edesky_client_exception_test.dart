import 'package:edeskyclient/edeskyclient.dart';
import 'package:test/test.dart';

import 'fixtures/fixture.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('equality', () {
    final first = EdeskyClientException('This is an exception!', 500);
    final second = EdeskyClientException('This is an exception!', 500);

    expect(first, second);
  });

  test('toString returns correct value', () {
    final e = EdeskyClientException(errorNotLoggedIn, 401);
    expect(
      e.toString(),
      'EdeskyClientException: ${e.message}, ${e.statusCode}',
    );
  });
}
