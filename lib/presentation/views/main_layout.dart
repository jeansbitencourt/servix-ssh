import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../stores/host_store.dart';
import '../stores/shortcut_store.dart';
import '../stores/terminal_session_store.dart';
import 'dashboard_view.dart';
import 'hosts_view.dart';
import 'shortcuts_view.dart';
import 'terminal_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final HostStore _hostStore = sl<HostStore>();
  final ShortcutStore _shortcutStore = sl<ShortcutStore>();
  final TerminalSessionStore _terminalStore = sl<TerminalSessionStore>();

  void _onTabSelect(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(builder: (context) {
      final activeTerminalCount = _terminalStore.sessions.value.length;
      final hostCount = _hostStore.hosts.value.length;

      return Scaffold(
        body: Row(
          children: [
            // Left Sidebar
            Container(
              width: 250,
              decoration: const BoxDecoration(
                color: AppTheme.darkSurface,
                border: Border(right: BorderSide(color: AppTheme.darkBorder)),
              ),
              child: Column(
                children: [
                  // App Brand Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.terminal_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ControlPanel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'SSH Linux Suite',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Navigation Items
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard',
                        ),
                        const SizedBox(height: 4),
                        _buildNavItem(
                          index: 1,
                          icon: Icons.dns_rounded,
                          label: 'Servidores',
                          badge: hostCount > 0 ? hostCount.toString() : null,
                        ),
                        const SizedBox(height: 4),
                        _buildNavItem(
                          index: 2,
                          icon: Icons.flash_on_rounded,
                          label: 'Atalhos',
                        ),
                        const SizedBox(height: 4),
                        _buildNavItem(
                          index: 3,
                          icon: Icons.terminal_rounded,
                          label: 'Terminais',
                          badge: activeTerminalCount > 0 ? activeTerminalCount.toString() : null,
                          badgeColor: AppTheme.accent,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom System Status info
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSurfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.darkBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cofre Ativo',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'GNOME Keyring / KWallet',
                                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.shield_outlined, size: 16, color: AppTheme.success),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  DashboardView(
                    hostStore: _hostStore,
                    shortcutStore: _shortcutStore,
                    terminalStore: _terminalStore,
                    onNavigateToTab: _onTabSelect,
                  ),
                  HostsView(
                    hostStore: _hostStore,
                    shortcutStore: _shortcutStore,
                    terminalStore: _terminalStore,
                    onNavigateToTerminal: () => _onTabSelect(3),
                  ),
                  ShortcutsView(
                    shortcutStore: _shortcutStore,
                    hostStore: _hostStore,
                  ),
                  TerminalViewScreen(
                    terminalStore: _terminalStore,
                    hostStore: _hostStore,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    String? badge,
    Color? badgeColor,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _onTabSelect(index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary.withValues(alpha: 0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppTheme.accent : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
