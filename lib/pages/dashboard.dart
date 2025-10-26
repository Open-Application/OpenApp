import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/provider_helper.dart';
import '../utils/haptic_helper.dart';
import '../utils/network_helper.dart';
import '../components/rcc_list_view.dart';
import '../components/rcc_widget.dart';
import '../components/rcc_messenger.dart';
import '../components/rcc_animation.dart';
import '../l10n/app_localizations.dart';
import '../constants.dart';
import '../ui.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin, RccAnimationMixin {
  String? _expandedSection;
  final TextEditingController _configController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initializeAnimation(duration: AnimationDurations.medium, autoStart: true);
  }

  @override
  void dispose() {
    _configController.dispose();
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    if (preferencesProvider == null) {
      return RccPageScaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: RccListView(
            padding: UI.paddingSymmetric(horizontal: 20, vertical: 24),
            physics: const ClampingScrollPhysics(),
            children: [
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccPageHeader(
                      title: AppLocalizations.of(context)!.dashboard,
                      subtitle: AppLocalizations.of(context)!.networkControlCenter,
                    ),
                  ],
                ),
              ),
              SizedBox(height: UI.responsiveSpacing()),
              _buildQuickActions(context),
              SizedBox(height: UI.responsiveSpacing()),
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccSectionTitle(title: AppLocalizations.of(context)!.configuration),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildConfigurationCard(context),
                  ],
                ),
              ),
              SizedBox(height: UI.responsiveSpacing()),
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccSectionTitle(title: AppLocalizations.of(context)!.status),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildCompactStatusCard(context),
                  ],
                ),
              ),
              SizedBox(height: UI.responsiveSpacing()),
              RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RccSectionTitle(title: AppLocalizations.of(context)!.control),
                    SizedBox(height: UI.scaledDimension(12)),
                    _buildCompactControlCard(context),
                  ],
                ),
              ),
            ],
          ),
        );
    }

    return ListenableBuilder(
      listenable: preferencesProvider as ChangeNotifier,
      builder: (context, child) {
        final dynamic prefs = preferencesProvider;
        final showLogs = prefs.showServiceLogs ?? false;

        return RccPageScaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          child: RccListView(
              padding: UI.paddingSymmetric(horizontal: 20, vertical: 24),
              physics: const ClampingScrollPhysics(),
              children: [
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RccPageHeader(
                        title: AppLocalizations.of(context)!.dashboard,
                        subtitle: AppLocalizations.of(context)!.networkControlCenter,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: UI.responsiveSpacing()),
                _buildQuickActions(context),
                SizedBox(height: UI.responsiveSpacing()),
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RccSectionTitle(title: AppLocalizations.of(context)!.configuration),
                      SizedBox(height: UI.scaledDimension(12)),
                      _buildConfigurationCard(context),
                    ],
                  ),
                ),
                SizedBox(height: UI.responsiveSpacing()),
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RccSectionTitle(title: AppLocalizations.of(context)!.status),
                      SizedBox(height: UI.scaledDimension(12)),
                      _buildCompactStatusCard(context),
                    ],
                  ),
                ),
                SizedBox(height: UI.responsiveSpacing()),
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RccSectionTitle(title: AppLocalizations.of(context)!.control),
                      SizedBox(height: UI.scaledDimension(12)),
                      _buildCompactControlCard(context),
                    ],
                  ),
                ),
                SizedBox(height: UI.responsiveSpacing()),
                if (showLogs) ...[
                  RepaintBoundary(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RccSectionTitle(title: AppLocalizations.of(context)!.logs),
                        SizedBox(height: UI.scaledDimension(12)),
                        _buildLogsSection(context),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    final rccProvider = ProviderHelper.getRccProvider(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    if (rccProvider == null) {
      return const SizedBox.shrink();
    }

    return ListenableBuilder(
      listenable: rccProvider as ChangeNotifier,
      builder: (context, child) {
        final dynamic provider = rccProvider;
        final statusColor = provider.statusColor as Color;
        final isConnected = provider.status == 'STARTED';

        return Container(
          padding: UI.paddingAll(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                statusColor.withValues(alpha: 0.1),
                statusColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(UI.scaledDimension(16)),
            border: Border.all(color: statusColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: UI.adaptiveIconSize(72),
                    height: UI.adaptiveIconSize(72),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.2),
                          statusColor.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    isConnected ? Constants.iconShield : Constants.iconShieldOff,
                    size: UI.adaptiveIconSize(48),
                    color: statusColor,
                  ),
                  if (isConnected)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: UI.scaledDimension(16),
                        height: UI.scaledDimension(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: UI.scaledDimension(2),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: UI.scaledDimension(16)),
              Text(
                provider.getStatusText(context),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              SizedBox(height: UI.scaledDimension(4)),
              Text(
                _getStatusMessage(context, provider.status as String),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              if (isConnected) ...[
                SizedBox(height: UI.scaledDimension(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatChip(
                      context,
                      Constants.iconLock,
                      AppLocalizations.of(context)!.encrypted,
                      Colors.purple,
                    ),
                    SizedBox(width: UI.scaledDimension(12)),
                    _buildStatChip(
                      context,
                      Constants.iconVersion,
                      preferencesProvider?.versionWithPrefix ??
                          'v${Constants.projectVersion}',
                      Colors.blue,
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(height: UI.scaledDimension(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Constants.iconWarning,
                      size: UI.adaptiveIconSize(16),
                      color: Colors.orange.withValues(alpha: 0.8),
                    ),
                    SizedBox(width: UI.scaledDimension(6)),
                    Text(
                      AppLocalizations.of(context)!.unprotected,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.orange.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status.toUpperCase()) {
      case 'STOPPED':
        return l10n.stopped;
      case 'STARTED':
        return l10n.started;
      case 'STARTING':
        return l10n.starting;
      case 'STOPPING':
        return l10n.stopping;
      default:
        return status;
    }
  }

  Widget _buildCompactStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    final rccProvider = ProviderHelper.getRccProvider(context);

    if (rccProvider == null) {
      return const SizedBox.shrink();
    }

    return ListenableBuilder(
      listenable: rccProvider as ChangeNotifier,
      builder: (context, child) {
        final dynamic provider = rccProvider;
        final statusColor = provider.statusColor as Color;

        return Container(
          padding: UI.paddingAll(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(UI.scaledDimension(12)),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Constants.iconRccStatus,
                    size: UI.adaptiveIconSize(15),
                    color: statusColor,
                  ),
                  SizedBox(width: UI.scaledDimension(12)),
                  Text(
                    AppLocalizations.of(context)!.connectionStatus,
                    style: TextStyle(
                      fontSize: UI.buttonTextSize,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: UI.paddingSymmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    UI.scaledDimension(6),
                  ),
                ),
                child: Text(
                  _getLocalizedStatus(context, provider.status),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: UI.safeTextSize(11, maxScale: 1.1),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactControlCard(BuildContext context) {
    final theme = Theme.of(context);
    final rccProvider = ProviderHelper.getRccProvider(context);

    if (rccProvider == null) {
      return const SizedBox.shrink();
    }

    return ListenableBuilder(
      listenable: rccProvider as ChangeNotifier,
      builder: (context, child) {
        final dynamic provider = rccProvider;
        final isConnected = provider.status == 'STARTED';
        final isLoading = provider.isLoading as bool;

        void handleTap() async {
          final logProvider = ProviderHelper.getLogProvider(context);
          logProvider?.clearLogs();

          // Check if user is trying to connect (not disconnect)
          if (!isConnected) {
            final prefsProvider = ProviderHelper.getPreferencesProvider(context);
            if (prefsProvider != null) {
              final prefs = prefsProvider as dynamic;
              // Check if user has accepted privacy policy
              if (!prefs.privacyAccepted) {
                // Show privacy dialog and wait for user response
                final accepted = await _showServiceDataPrivacyDialog(context, requireAcceptance: true);

                if (!context.mounted) return;

                // If user didn't agree, don't proceed with connection
                if (accepted != true) {
                  return;
                }

                // User agreed, save the preference
                await prefs.setPrivacyAccepted(true);
              }
            }
          }

          final hasNetwork = await NetworkHelper.hasConnection();

          if (!context.mounted) return;

          if (!hasNetwork) {
            HapticUtils.error();
            RccMessenger.showError(
              context: context,
              message: AppLocalizations.of(context)!.noNetworkConnection,
            );
            return;
          }

          HapticUtils.primaryAction();
          provider.toggle(context);
        }

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(UI.scaledDimension(12)),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (provider.isButtonEnabled as bool && !isLoading)
                  ? handleTap
                  : null,
              borderRadius: BorderRadius.circular(UI.scaledDimension(12)),
              child: Container(
                padding: UI.paddingAll(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          RccLoadingIndicator.small(
                            color: theme.colorScheme.primary,
                          )
                        else
                          Icon(
                            isConnected ? Constants.iconStop : Constants.iconStart,
                            color: isConnected
                                ? Colors.red
                                : theme.colorScheme.primary,
                            size: UI.adaptiveIconSize(15),
                          ),
                        SizedBox(width: UI.scaledDimension(12)),
                        Text(
                          provider.getButtonText(context),
                          style: TextStyle(
                            fontSize: UI.buttonTextSize,
                            fontWeight: FontWeight.w600,
                            color: isConnected
                                ? Colors.red
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Constants.iconChevronRight,
                      size: UI.adaptiveIconSize(15),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getStatusMessage(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'STARTED':
        return l10n.yourInternetIsSecure;
      case 'STARTING':
        return l10n.establishingSecureConnection;
      case 'STOPPING':
        return l10n.closingSecureConnection;
      default:
        return l10n.yourInternetIsExposed;
    }
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: UI.paddingSymmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UI.scaledDimension(20)),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: UI.adaptiveIconSize(14), color: color),
          SizedBox(width: UI.responsiveSpacing(4)),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsSection(BuildContext context) {
    final theme = Theme.of(context);
    final logProvider = ProviderHelper.getLogProvider(context);

    if (logProvider == null) {
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
          children: [
            Icon(
              Constants.iconTerminal,
              size: UI.adaptiveIconSize(15),
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(width: UI.scaledDimension(12)),
            Text(
              'Service Logs (Provider not available)',
              style: TextStyle(
                fontSize: UI.buttonTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return RccExpandableItem(
      icon: Constants.iconTerminal,
      title: AppLocalizations.of(context)!.serviceLogs,
      isExpanded: _expandedSection == 'logs',
      onTap: () {
        HapticUtils.selectionClick();
        setState(() {
          _expandedSection = _expandedSection == 'logs' ? null : 'logs';
        });
      },
      expandedAction: IconButton(
        icon: Icon(
          Constants.iconCopy,
          size: UI.adaptiveIconSize(15),
          color: theme.colorScheme.primary,
        ),
        onPressed: () async {
          final logs = (logProvider as dynamic).exportLogs();
          await Clipboard.setData(ClipboardData(text: logs));
          if (context.mounted) {
            RccMessenger.showInfo(
              context: context,
              message: AppLocalizations.of(context)!.logsCopiedToClipboard,
            );
          }
        },
        tooltip: AppLocalizations.of(context)!.copyLogs,
        constraints: BoxConstraints(),
        padding: UI.paddingAll(0),
      ),
      expandedContent: ListenableBuilder(
        listenable: logProvider as ChangeNotifier,
        builder: (context, child) {
          final dynamic provider = logProvider;
          final logs = provider.logs as List;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: UI.scaledDimension(16)),
              Container(
                height: UI.scaledDimension(300),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(UI.scaledDimension(8)),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: logs.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noLogsYet,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      )
                    : RccListViewBuilder(
                        padding: UI.paddingAll(12),
                        physics: const ClampingScrollPhysics(),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final String logLine = logs[index];
                          Color logColor;
                          if (logLine.contains('[E]')) {
                            logColor = Colors.red.shade400;
                          } else if (logLine.contains('[W]')) {
                            logColor = Colors.orange.shade400;
                          } else if (logLine.contains('[D]') ||
                              logLine.contains('[V]')) {
                            logColor = Colors.blue.shade400;
                          } else {
                            logColor = theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            );
                          }

                          return Padding(
                            padding: UI.paddingOnly(bottom: 4),
                            child: Text(
                              logLine,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: UI.safeTextSize(11, maxScale: 1.3),
                                height: 1.4,
                                color: logColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: UI.responsiveSpacing(8)),
              Text(
                AppLocalizations.of(context)!.logEntries(logs.length),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: UI.safeTextSize(10, maxScale: 1.2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }


  Future<bool?> _showServiceDataPrivacyDialog(BuildContext context, {bool requireAcceptance = false}) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: !requireAcceptance,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.serviceDataPrivacy(Constants.appName),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.serviceDataCollectionTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: UI.scaledDimension(8)),
              Text(
                l10n.serviceDataCollectionAnswer,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: UI.scaledDimension(16)),
              Text(
                l10n.serviceDataPurposeTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: UI.scaledDimension(8)),
              Text(
                l10n.serviceDataPurposeAnswer,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: UI.scaledDimension(16)),
              Text(
                l10n.serviceDataSharingTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: UI.scaledDimension(8)),
              Text(
                l10n.serviceDataSharingAnswer,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          if (requireAcceptance) ...[
            TextButton(
              onPressed: () {
                HapticUtils.selectionClick();
                Navigator.of(context).pop(false);
              },
              child: Text(
                l10n.close,
                style: TextStyle(
                  fontSize: UI.buttonTextSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                HapticUtils.primaryAction();
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                l10n.agree,
                style: TextStyle(
                  fontSize: UI.buttonTextSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                HapticUtils.selectionClick();
                Navigator.of(context).pop();
              },
              child: Text(
                l10n.close,
                style: TextStyle(
                  fontSize: UI.buttonTextSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfigurationCard(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesProvider = ProviderHelper.getPreferencesProvider(context);

    if (preferencesProvider == null) {
      return const SizedBox.shrink();
    }

    return ListenableBuilder(
      listenable: preferencesProvider as ChangeNotifier,
      builder: (context, child) {
        final dynamic provider = preferencesProvider;
        final hasConfig = provider.hasUserConfig as bool;
        final timestamp = provider.userConfigTimestamp as DateTime?;

        final String title = hasConfig
            ? 'Saved ${_formatTimestamp(timestamp)}'
            : AppLocalizations.of(context)!.noCustomConfig;

        return RccExpandableItem(
          icon: Constants.iconDocumentText,
          title: title,
          isExpanded: _expandedSection == 'config',
          onTap: () {
            HapticUtils.selectionClick();
            setState(() {
              _expandedSection = _expandedSection == 'config' ? null : 'config';
              if (_expandedSection == 'config') {
                _configController.text = provider.userEncodedConfig ?? '';
              }
            });
          },
          trailingAction: GestureDetector(
            onTap: () {
              HapticUtils.selectionClick();
              _showServiceDataPrivacyDialog(context);
            },
            child: Icon(
              Constants.iconInfo,
              size: UI.adaptiveIconSize(15),
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          expandedContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: UI.scaledDimension(16)),
              Text(
                AppLocalizations.of(context)!.enterBase64Config,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: UI.scaledDimension(12)),
              Container(
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(UI.scaledDimension(8)),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _configController,
                  maxLines: 5,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: UI.safeTextSize(12, maxScale: 1.2),
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.pasteConfigHere,
                    border: InputBorder.none,
                    contentPadding: UI.paddingAll(12),
                  ),
                ),
              ),
              SizedBox(height: UI.responsiveSpacing(16)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Remove trailing spaces and newlines from each line
                        final config = _configController.text
                            .split('\n')
                            .map((line) => line.trimRight())
                            .join('\n')
                            .trim();
                        if (config.isEmpty) {
                          HapticUtils.error();
                          RccMessenger.showError(
                            context: context,
                            message: AppLocalizations.of(context)!.configEmpty,
                          );
                          return;
                        }

                        HapticUtils.success();
                        await provider.setUserConfig(config);
                        if (context.mounted) {
                          setState(() {
                            _expandedSection = null;
                          });
                          RccMessenger.showSuccess(
                            context: context,
                            message: AppLocalizations.of(context)!.configSaved,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: UI.paddingSymmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            UI.scaledDimension(8),
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.saveConfiguration,
                        style: TextStyle(
                          fontSize: UI.buttonTextSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (hasConfig) ...[
                    SizedBox(width: UI.responsiveSpacing(12)),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          HapticUtils.selectionClick();
                          await provider.clearUserConfig();
                          _configController.clear();
                          if (context.mounted) {
                            RccMessenger.showInfo(
                              context: context,
                              message:
                                  AppLocalizations.of(context)!.configCleared,
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: UI.paddingSymmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              UI.scaledDimension(8),
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.clearConfiguration,
                          style: TextStyle(
                            fontSize: UI.buttonTextSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

