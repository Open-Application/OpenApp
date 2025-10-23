import 'package:flutter/material.dart';
import 'rcc_modal.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../ui.dart';

class LegalDialogs {
  static void showTermsOfUse(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    RccModal.showDetails(
      context: context,
      title: localizations.termsOfUse,
      icon: Constants.iconDocumentText,
      sections: [
        RccModalSection(
          title: '1. ${localizations.educationalUseOnly}',
          children: [
            Text(
              localizations.educationalUseOnlyText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        RccModalSection(
          title: '2. ${localizations.noWarranty}',
          children: [
            Text(
              localizations.noWarrantyText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        RccModalSection(
          title: '3. ${localizations.userResponsibility}',
          children: [
            Text(
              localizations.userResponsibilityText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        RccModalSection(
          title: '4. ${localizations.academicIntegrity}',
          children: [
            Text(
              localizations.academicIntegrityText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static void showPrivacyPolicy(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    RccModal.showDetails(
      context: context,
      title: localizations.privacyPolicy,
      icon: Constants.iconPrivacyTip,
      sections: [
        RccModalSection(
          title: '1. ${localizations.dataCollection}',
          children: [
            Text(
              localizations.dataCollectionText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        RccModalSection(
          title: '2. ${localizations.networkTraffic}',
          children: [
            Text(
              localizations.networkTrafficText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        RccModalSection(
          title: '3. ${localizations.thirdPartyServices}',
          children: [
            Text(
              localizations.thirdPartyServicesText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        RccModalSection(
          title: '4. ${localizations.dataSecurity}',
          children: [
            Text(
              localizations.dataSecurityText,
              style: TextStyle(
                fontSize: UI.bodyTextSize,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}