import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rcc_modal.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../ui.dart';
import '../utils/legal_helper.dart';
import '../providers/preferences_provider.dart';

class LegalDialogs {
  /// Show the full Terms of Use / User Agreement from assets
  static Future<void> showTermsOfUse(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    // Load the terms of use content first (fast, no need for loading dialog)
    final content = await LegalHelper.loadUserAgreement();

    if (!context.mounted) return;

    // Show the terms of use with optional agree button
    _showLegalDocument(
      context: context,
      title: localizations.termsOfUse,
      content: content,
      icon: Constants.iconArticle,
      requireAcceptance: !prefs.termsAccepted,
      onAccept: () async {
        await prefs.setTermsAccepted(true);
      },
    );
  }

  /// Show the full Privacy Policy from assets
  static Future<void> showPrivacyPolicy(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    // Load the privacy policy content first (fast, no need for loading dialog)
    final content = await LegalHelper.loadPrivacyPolicy();

    if (!context.mounted) return;

    // Show the privacy policy with optional agree button
    _showLegalDocument(
      context: context,
      title: localizations.privacyPolicy,
      content: content,
      icon: Constants.iconPrivacyTip,
      requireAcceptance: !prefs.privacyPolicyAccepted,
      onAccept: () async {
        await prefs.setPrivacyPolicyAccepted(true);
      },
    );
  }

  /// Show the software license from assets
  static Future<void> showLicense(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    // Load the license content first (fast, no need for loading dialog)
    final content = await LegalHelper.loadLicense();

    if (!context.mounted) return;

    // Show the license (no acceptance required, just informational)
    _showLegalDocument(
      context: context,
      title: localizations.openSourceLicense,
      content: content,
      icon: Constants.iconDocumentText,
      requireAcceptance: false,
    );
  }

  /// Internal method to show a legal document in a modal
  static void _showLegalDocument({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    bool requireAcceptance = false,
    Future<void> Function()? onAccept,
  }) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    RccModal.show(
      context: context,
      titleText: title,
      titleIcon: icon,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: UI.paddingSymmetric(horizontal: 24, vertical: 16),
        child: SelectableText(
          content,
          style: TextStyle(
            fontSize: UI.safeTextSize(13, maxScale: 1.3),
            height: 1.6,
            color: theme.colorScheme.onSurface,
            fontFamily: 'monospace',
          ),
        ),
      ),
      footerButton: requireAcceptance
          ? RccModalButton(
              text: localizations.agree,
              isPrimary: true,
              onPressed: () async {
                if (onAccept != null) {
                  await onAccept();
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            )
          : RccModalButton(
              text: localizations.close,
              isPrimary: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
    );
  }
}