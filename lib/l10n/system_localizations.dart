import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

Locale resolveAppLocale(
  List<Locale>? preferredLocales,
  Iterable<Locale> supportedLocales,
) {
  // A country match alone must not select a different language.
  final supportedLanguages = supportedLocales
      .map((locale) => locale.languageCode)
      .toSet();
  final matchingLocales = preferredLocales
      ?.where((locale) => supportedLanguages.contains(locale.languageCode))
      .toList();
  return basicLocaleListResolution(matchingLocales, supportedLocales);
}

/// Localized app messages created outside the widget tree.
AppLocalizations get systemLocalizations => lookupAppLocalizations(
  resolveAppLocale(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  ),
);
