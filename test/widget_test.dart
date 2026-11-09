import 'package:flutter/material.dart';
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

  testWidgets('upload options default to five downloads and seven days', (
    tester,
  ) async {
    UploadOptions? selectedOptions;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                selectedOptions = await showDialog<UploadOptions>(
                  context: context,
                  builder: (_) => const UploadOptionsDialog(language: 'en'),
                );
              },
              child: const Text('Open upload options'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open upload options'));
    await tester.pumpAndSettle();
    expect(find.text('Download limit'), findsOneWidget);
    expect(find.text('Expiration date'), findsOneWidget);
    expect(find.text('Password protection'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(selectedOptions?.downloadLimit, 5);
    expect(selectedOptions?.expiryDays, 7);
    expect(selectedOptions?.password, isEmpty);
  });
}
