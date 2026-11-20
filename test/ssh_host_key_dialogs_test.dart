import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servix/domain/entities/ssh_host_key.dart';
import 'package:servix/l10n/app_localizations.dart';
import 'package:servix/presentation/widgets/ssh_host_key_dialogs.dart';

void main() {
  const previous = SSHHostKey(
    'server.example',
    2222,
    'ssh-ed25519',
    'SHA256:old',
  );
  const presented = SSHHostKey(
    'server.example',
    2222,
    'ssh-ed25519',
    'SHA256:new',
  );

  Future<SSHHostKeyDialogs> setup(WidgetTester tester) async {
    final dialogs = SSHHostKeyDialogs();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: dialogs.navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(),
      ),
    );
    return dialogs;
  }

  testWidgets(
    'Host trust needs explicit consent and is dismissed on cancellation',
    (tester) async {
      final dialogs = await setup(tester);
      final connectionEnded = Completer<void>();
      final trust = dialogs.trust(presented, connectionEnded.future);
      await tester.pumpAndSettle();
      expect(find.text('server.example:2222'), findsOneWidget);
      expect(find.text(presented.identity), findsOneWidget);
      await tester.tap(find.text('Trust this key'));
      await tester.pumpAndSettle();
      expect(await trust, isTrue);
      connectionEnded.complete();

      final cancelled = Completer<void>();
      final second = dialogs.trust(presented, cancelled.future);
      await tester.pumpAndSettle();
      cancelled.complete();
      await tester.pumpAndSettle();
      expect(await second, isFalse);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'Rotation displays both identities and needs a second confirmation',
    (tester) async {
      final dialogs = await setup(tester);
      var replacements = 0;
      final review = dialogs.changed(
        previous,
        presented,
        () async => replacements++,
      );
      await tester.pumpAndSettle();
      expect(find.text(previous.identity), findsOneWidget);
      expect(find.text(presented.identity), findsOneWidget);
      await tester.tap(find.text('Review replacement'));
      await tester.pumpAndSettle();
      expect(replacements, 0);
      await tester.tap(
        find.widgetWithText(FilledButton, 'Replace trusted key'),
      );
      await tester.pumpAndSettle();
      expect(replacements, 1);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await review;
    },
  );
}
