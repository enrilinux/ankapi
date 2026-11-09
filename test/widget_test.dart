import 'package:flutter_test/flutter_test.dart';

import 'package:ankapi/main.dart';

void main() {
  test('English is the default language and five languages are available', () {
    expect(AppStrings.text('homeTitle', 'en'), 'Ankapi files');
    expect(AppStrings.supportedLanguages,
        containsAll(['en', 'it', 'es', 'fr', 'de']));
  });

  test('unknown languages fall back to English', () {
    expect(AppStrings.text('homeTitle', 'unknown'), 'Ankapi files');
  });
}
