import 'package:flutter/services.dart';
import '../constants.dart';

class LegalHelper {
  static Future<String> loadPrivacyPolicy() async {
    try {
      return await rootBundle.loadString(Constants.privacyPolicyPath);
    } catch (e) {
      return 'Failed to load Privacy Policy. Please try again later.';
    }
  }

  static Future<String> loadUserAgreement() async {
    try {
      return await rootBundle.loadString(Constants.userAgreementPath);
    } catch (e) {
      return 'Failed to load User Agreement. Please try again later.';
    }
  }
}
