import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_brand.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 1200;
    final vaultName = switch (defaultTargetPlatform) {
      TargetPlatform.linux => 'GNOME Keyring / KWallet',
      TargetPlatform.macOS => 'Chaves do macOS',
      TargetPlatform.windows => 'Credenciais do Windows',
      _ => 'Cofre do sistema',
    };

    return SignalBuilder(
      builder: (context) {
        final activeTerminalCount = _terminalStore.sessions.value.length;
        final hostCount = _hostStore.hosts.value.length;

        return Scaffold(
          body: Row(
            children: [
              // Left Sidebar
              Container(
                width: compact ? 56 : 250,
                decoration: const BoxDecoration(
                  color: AppTheme.darkSurface,
                  border: Border(right: BorderSide(color: AppTheme.darkBorder)),
                ),
                child: Column(
                  children: [
                    _buildBrand(compact),

                    // Navigation Items
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 6 : 12,
                        ),
                        children: [
                          _buildNavItem(
                            index: 0,
                            compact: compact,
                            icon: Icons.dashboard_rounded,
                            label: 'Dashboard',
                          ),
                          const SizedBox(height: 4),
                          _buildNavItem(
                            index: 1,
                            compact: compact,
                            icon: Icons.dns_rounded,
                            label: 'Servidores',
                            badge: hostCount > 0 ? hostCount.toString() : null,
                          ),
                          const SizedBox(height: 4),
                          _buildNavItem(
                            index: 2,
                            compact: compact,
                            icon: Icons.flash_on_rounded,
                            label: 'Atalhos',
                          ),
                          const SizedBox(height: 4),
                          _buildNavItem(
                            index: 3,
                            compact: compact,
                            icon: Icons.terminal_rounded,
                            label: 'Terminais',
                            badge: activeTerminalCount > 0
                                ? activeTerminalCount.toString()
                                : null,
                            badgeColor: AppTheme.accent,
                          ),
                        ],
                      ),
                    ),

                    if (compact)
                      Tooltip(
                        message: 'Cofre Ativo · $vaultName',
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: AppTheme.success,
                          ),
                        ),
                      )
                    else
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cofre Ativo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    vaultName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.shield_outlined,
                              size: 16,
                              color: AppTheme.success,
                            ),
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
                      isVisible: _currentIndex == 3,
                      terminalStore: _terminalStore,
                      hostStore: _hostStore,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrand(bool compact) {
    final icon = Image.asset(
      AppBrand.iconAsset,
      width: compact ? 42 : 52,
      height: compact ? 42 : 52,
      excludeFromSemantics: true,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 0 : 16,
        vertical: compact ? 10 : 18,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
      ),
      child: compact
          ? Center(
              child: Tooltip(message: AppBrand.title, child: icon),
            )
          : Row(
              children: [
                icon,
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppBrand.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        AppBrand.slogan,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required bool compact,
    required IconData icon,
    required String label,
    String? badge,
    Color? badgeColor,
  }) {
    final isSelected = _currentIndex == index;

    final navIcon = Icon(
      icon,
      size: 20,
      color: isSelected ? AppTheme.accent : const Color(0xFF94A3B8),
    );

    return Tooltip(
      message: compact ? (badge == null ? label : '$label ($badge)') : '',
      child: InkWell(
        onTap: () => _onTabSelect(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 0 : 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: compact
              ? Center(
                  child: Badge(
                    isLabelVisible: badge != null,
                    label: badge == null ? null : Text(badge),
                    backgroundColor: badgeColor ?? AppTheme.primary,
                    child: navIcon,
                  ),
                )
              : Row(
                  children: [
                    navIcon,
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
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
      ),
    );
  }
}
