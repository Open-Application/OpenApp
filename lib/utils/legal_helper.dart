import 'package:flutter/services.dart';
import '../constants.dart';

/// Helper class to load legal documents from assets
class LegalHelper {
  /// Load the privacy policy text from assets
  static Future<String> loadPrivacyPolicy() async {
    try {
      return await rootBundle.loadString(Constants.privacyPolicyPath);
    } catch (e) {
      return 'Failed to load Privacy Policy. Please try again later.';
    }
  }

  /// Load the user agreement (terms of use) text from assets
  static Future<String> loadUserAgreement() async {
    try {
      return await rootBundle.loadString(Constants.userAgreementPath);
    } catch (e) {
      return 'Failed to load User Agreement. Please try again later.';
    }
  }

  /// Load the license text from assets
  static Future<String> loadLicense() async {
    try {
      return await rootBundle.loadString(Constants.licensePath);
    } catch (e) {
      return 'Failed to load License. Please try again later.';
    }
  }

  /// Load all legal documents
  static Future<Map<String, String>> loadAllLegalDocuments() async {
    final privacyPolicy = await loadPrivacyPolicy();
    final userAgreement = await loadUserAgreement();
    final license = await loadLicense();

    return {
      'privacyPolicy': privacyPolicy,
      'userAgreement': userAgreement,
      'license': license,
    };
  }
}
