import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rcc_modal.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../ui.dart';
import '../utils/legal_helper.dart';
import '../providers/preferences_provider.dart';

class LegalDialogs {
  static Future<void> showTermsOfUse(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    final content = await LegalHelper.loadUserAgreement();

    if (!context.mounted) return;
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

  static Future<void> showPrivacyPolicy(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    final content = await LegalHelper.loadPrivacyPolicy();

    if (!context.mounted) return;
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