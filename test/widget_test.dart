import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:control_panel/core/theme/app_theme.dart';

void main() {
  test('AppTheme darkTheme configuration smoke test', () {
    final theme = AppTheme.darkTheme;
    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.brightness, Brightness.dark);
  });
}
