import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class AppTerminalTheme {
  static const fontFamily = 'TerminalMono';
  static const textStyle = TerminalStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.25,
  );

  static const TerminalTheme dark = TerminalTheme(
    cursor: Color(0xFF38BDF8),
    selection: Color(0x446366F1),
    foreground: Color(0xFFDCE4EE),
    background: Color(0xFF0B1018),
    black: Color(0xFF1E293B),
    red: Color(0xFFF43F5E),
    green: Color(0xFF10B981),
    yellow: Color(0xFFFBBF24),
    blue: Color(0xFF38BDF8),
    magenta: Color(0xFFA855F7),
    cyan: Color(0xFF06B6D4),
    white: Color(0xFFE2E8F0),
    brightBlack: Color(0xFF738299),
    brightRed: Color(0xFFFB7185),
    brightGreen: Color(0xFF34D399),
    brightYellow: Color(0xFFFDE047),
    brightBlue: Color(0xFF7DD3FC),
    brightMagenta: Color(0xFFC084FC),
    brightCyan: Color(0xFF67E8F9),
    brightWhite: Color(0xFFFFFFFF),
    searchHitBackground: Color(0xFFFBBF24),
    searchHitBackgroundCurrent: Color(0xFFF59E0B),
    searchHitForeground: Color(0xFF0F172A),
  );
}
