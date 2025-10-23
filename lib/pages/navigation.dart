import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../utils/haptic_helper.dart';
import '../l10n/app_localizations.dart';
import '../ui.dart';

class Navigation extends StatelessWidget {
  final Widget child;

  const Navigation({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) {
      return 0;
    }
    if (location.startsWith('/profile')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    // Close any open modals/dialogs before navigating
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    UI.init(context);
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: child,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              height: UI.screenSize == ScreenSize.compact
                  ? UI.scaledDimension(52)
                  : UI.getBottomNavHeight(),
              padding: UI.paddingSymmetric(
                horizontal: UI.screenSize == ScreenSize.compact ? 4 : 8,
                vertical: UI.screenSize == ScreenSize.compact ? 4 : 6
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    icon: Constants.iconDashboard,
                    selectedIcon: Constants.iconDashboardFill,
                    label: AppLocalizations.of(context)!.dashboard,
                    isSelected: selectedIndex == 0,
                    onTap: () => _onItemTapped(0, context),
                  ),
                  _buildNavItem(
                    context,
                    icon: Constants.iconPerson,
                    selectedIcon: Constants.iconPerson,
                    label: AppLocalizations.of(context)!.profile,
                    isSelected: selectedIndex == 1,
                    onTap: () => _onItemTapped(1, context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticUtils.selectionClick();
            onTap();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: UI.adaptiveIconSize(
                  UI.screenSize == ScreenSize.compact ? 20 : 22
                ),
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(height: UI.scaledDimension(
                UI.screenSize == ScreenSize.compact ? 2 : 4
              )),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: UI.safeTextSize(
                    UI.screenSize == ScreenSize.compact ? 10 : 11,
                    maxScale: 1.2
                  ),
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}