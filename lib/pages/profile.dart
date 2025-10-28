import 'package:flutter/material.dart';
import '../utils/haptic_helper.dart';
import '../utils/provider_helper.dart';
import '../components/legal_dialogs.dart';
import '../components/rcc_widget.dart';
import '../components/rcc_scroll.dart';
import '../components/rcc_list_view.dart';
import '../components/rcc_animation.dart';
import '../components/rcc_modal.dart';
import '../l10n/app_localizations.dart';
import '../constants.dart';
import '../ui.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with TickerProviderStateMixin, RccAnimationMixin {
  String? _expandedSection;
  dynamic _preferencesProvider;

  @override
  void initState() {
    super.initState();

    initializeAnimation(duration: AnimationDurations.medium, autoStart: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupProviderListeners();
    });
  }

  void _setupProviderListeners() {
    _preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    if (_preferencesProvider != null) {
      (_preferencesProvider as ChangeNotifier).addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (_preferencesProvider != null) {
      (_preferencesProvider as ChangeNotifier).removeListener(
        _onProviderChanged,
      );
    }
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UI.init(context);
    ProviderHelper.getPreferencesProvider(context);

    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    final theme = Theme.of(context);

    return RccPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: RepaintBoundary(
        child: RccListView(
            padding: UI.paddingSymmetric(horizontal: 20, vertical: 24),
            physics: const NoOverscrollPhysics(),
            children: [
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccPageHeader(
                      title: AppLocalizations.of(context)!.profile,
                      subtitle: AppLocalizations.of(context)!.accountManagementHub,
                    ),
                  ],
                ),
              ),
              SizedBox(height: UI.responsiveSpacing()),
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccSectionTitle(
                      title: AppLocalizations.of(context)!.settings,
                    ),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildCompactThemeSelector(context),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildCompactLanguageSelector(context),
                  ],
                ),
              ),
              SizedBox(height: UI.responsiveSpacing()),
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccSectionTitle(
                      title: AppLocalizations.of(context)!.privacy,
                    ),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildPrivacySection(context),
                  ],
                ),
              ),
              SizedBox(height: UI.responsiveSpacing()),
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccSectionTitle(title: AppLocalizations.of(context)!.about),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildAboutSection(context),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildCompactThemeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);
    final isDark = preferencesProvider?.isDarkMode(context) ?? false;

    return Container(
      padding: UI.paddingAll(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDark ? Constants.iconMoon : Constants.iconSun,
                size: UI.adaptiveIconSize(20),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.darkMode,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          _buildThemeToggle(context),
        ],
      ),
    );
  }

  Widget _buildCompactLanguageSelector(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    String currentLanguage = localizations.systemDefault;
    if (preferencesProvider != null) {
      try {
        final String code = preferencesProvider.getCurrentLanguageCode();
        currentLanguage = Constants.nativeLanguageNames[code] ?? localizations.systemDefault;
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: UI.paddingAll(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Constants.iconLanguage,
                      size: UI.adaptiveIconSize(20),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: UI.scaledDimension(12)),
                    Text(
                      localizations.language,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      currentLanguage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    SizedBox(width: UI.scaledDimension(8)),
                    Icon(
                      Constants.iconChevronRight,
                      size: UI.adaptiveIconSize(16),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    String currentCode = 'system';
    if (preferencesProvider != null) {
      try {
        currentCode = preferencesProvider.getCurrentLanguageCode();
      } catch (_) {}
    }

    final languages = Constants.nativeLanguageNames.entries
        .map((entry) => {'code': entry.key, 'name': entry.value})
        .toList();

    languages.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

    RccModal.show(
      context: context,
      titleText: localizations.selectLanguage,
      titleIcon: Constants.iconLanguage,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: UI.paddingSymmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              localizations.systemDefault,
              'system',
              currentCode == 'system',
            ),
            ...languages.map((lang) => _buildLanguageOption(
              context,
              lang['name'] as String,
              lang['code'] as String,
              currentCode == lang['code'],
            )),
          ],
        ),
      ),
      footerButton: RccModalButton(
        text: localizations.close,
        isPrimary: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String code,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: preferencesProvider != null
            ? () async {
                HapticUtils.selectionClick();
                try {
                  if (code == 'system') {
                    await preferencesProvider.setLanguage(null);
                  } else {
                    await preferencesProvider.setLanguage(code);
                  }
                } catch (_) {}
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: UI.paddingSymmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              if (isSelected)
                Icon(
                  Constants.iconCheck,
                  size: UI.adaptiveIconSize(20),
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);
    final isDark = preferencesProvider?.isDarkMode(context) ?? false;

    return GestureDetector(
      onTap: preferencesProvider != null
          ? () {
              HapticUtils.selectionClick();
              try {
                preferencesProvider.toggleTheme();
              } catch (_) {}
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: UI.scaledDimension(52),
        height: UI.scaledDimension(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UI.scaledDimension(20)),
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.surfaceContainerHighest,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isDark ? UI.scaledDimension(26) : UI.scaledDimension(2),
              top: UI.scaledDimension(2),
              child: Container(
                width: UI.scaledDimension(24),
                height: UI.scaledDimension(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isDark
                      ? Constants.iconMoon
                      : Constants.iconSun,
                  size: UI.adaptiveIconSize(14),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    return RccExpandableItem(
      icon: Constants.iconInfo,
      title: AppLocalizations.of(context)!.aboutProject(Constants.appName),
      isExpanded: _expandedSection == 'about',
      onTap: () async {
        HapticUtils.selectionClick();
        final preferencesProvider = ProviderHelper.getPreferencesProvider(
          context,
        );
        preferencesProvider?.incrementAboutClickCount();

        if (context.mounted) {
          setState(() {
            _expandedSection = _expandedSection == 'about' ? null : 'about';
          });
        }
      },
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: UI.scaledDimension(16)),
          Row(
            children: [
              Container(
                width: UI.scaledDimension(40),
                height: UI.scaledDimension(40),
                child: Image.asset(
                  Constants.iconAppIcon,
                  width: UI.scaledDimension(40),
                  height: UI.scaledDimension(40),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Constants.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.version} ${preferencesProvider?.version ?? Constants.projectVersion}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: UI.scaledDimension(16)),
          Text(
            AppLocalizations.of(
              context,
            )!.aboutProjectText(Constants.appName),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          SizedBox(height: UI.scaledDimension(16)),
          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
          SizedBox(height: UI.scaledDimension(16)),
          _buildInfoRow(
            context,
            AppLocalizations.of(context)!.coreLibrary,
            'librcc',
          ),
          SizedBox(height: UI.scaledDimension(12)),
          _buildInfoRow(
            context,
            AppLocalizations.of(context)!.purpose,
            AppLocalizations.of(context)!.educational,
          ),
          SizedBox(height: UI.scaledDimension(12)),
          _buildInfoRow(
            context,
            AppLocalizations.of(context)!.technology,
            AppLocalizations.of(context)!.networkResearch,
          ),
          SizedBox(height: UI.scaledDimension(12)),
          GestureDetector(
            onTap: () => _showLicenseDialog(context),
            child: _buildInfoRow(
              context,
              AppLocalizations.of(context)!.openSourceLicense,
              Constants.licenseText,
              isClickable: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return Column(
      children: [
        RccListItem(
          icon: Constants.iconArticle,
          title: AppLocalizations.of(context)!.termsOfUse,
          onTap: () => LegalDialogs.showTermsOfUse(context),
        ),
        const SizedBox(height: 12),
        RccListItem(
          icon: Constants.iconPrivacyTip,
          title: AppLocalizations.of(context)!.privacyPolicy,
          onTap: () => LegalDialogs.showPrivacyPolicy(context),
        ),
      ],
    );
  }

  void _showLicenseDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    RccModal.showInfo(
      context: context,
      title: localizations.openSourceLicense,
      message: Constants.licenseFullText,
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isClickable = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
        Container(
          padding: UI.paddingSymmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isClickable) ...[
                SizedBox(width: UI.scaledDimension(4)),
                Icon(
                  Constants.iconOpenInNew,
                  size: UI.adaptiveIconSize(12),
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
