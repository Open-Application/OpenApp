class RegionHelper {
  static String getRegionName(String code) {
    switch (code.toUpperCase()) {
      case 'UK':
      case 'GB':
        return 'United Kingdom';
      case 'DE':
        return 'Germany';
      case 'FR':
        return 'France';
      case 'NL':
        return 'Netherlands';
      case 'CH':
        return 'Switzerland';
      case 'IT':
        return 'Italy';
      case 'ES':
        return 'Spain';
      case 'SE':
        return 'Sweden';
      case 'NO':
        return 'Norway';
      case 'DK':
        return 'Denmark';
      case 'FI':
        return 'Finland';
      case 'PL':
        return 'Poland';
      case 'IE':
        return 'Ireland';
      case 'BE':
        return 'Belgium';
      case 'AT':
        return 'Austria';
      case 'CZ':
        return 'Czech Republic';
      case 'PT':
        return 'Portugal';
      case 'GR':
        return 'Greece';
      case 'RO':
        return 'Romania';
      case 'HU':
        return 'Hungary';
      case 'US':
        return 'United States';
      case 'CA':
        return 'Canada';
      case 'MX':
        return 'Mexico';
      case 'BR':
        return 'Brazil';
      case 'AR':
        return 'Argentina';
      case 'CL':
        return 'Chile';
      case 'CO':
        return 'Colombia';
      case 'PE':
        return 'Peru';
      case 'JP':
        return 'Japan';
      case 'KR':
        return 'South Korea';
      case 'CN':
        return 'China';
      case 'HK':
        return 'Hong Kong';
      case 'TW':
        return 'Taiwan';
      case 'SG':
        return 'Singapore';
      case 'MY':
        return 'Malaysia';
      case 'TH':
        return 'Thailand';
      case 'VN':
        return 'Vietnam';
      case 'PH':
        return 'Philippines';
      case 'ID':
        return 'Indonesia';
      case 'IN':
        return 'India';
      case 'PK':
        return 'Pakistan';
      case 'BD':
        return 'Bangladesh';
      case 'AU':
        return 'Australia';
      case 'NZ':
        return 'New Zealand';
      case 'AE':
        return 'United Arab Emirates';
      case 'SA':
        return 'Saudi Arabia';
      case 'IL':
        return 'Israel';
      case 'TR':
        return 'Turkey';
      case 'EG':
        return 'Egypt';
      case 'ZA':
        return 'South Africa';
      case 'NG':
        return 'Nigeria';
      case 'KE':
        return 'Kenya';
      case 'MA':
        return 'Morocco';
      case 'RU':
        return 'Russia';
      case 'UA':
        return 'Ukraine';
      case 'KZ':
        return 'Kazakhstan';

      default:
        return code;
    }
  }

  static String getRegionFlag(String code) {
    switch (code.toUpperCase()) {
      case 'UK':
      case 'GB':
        return '🇬🇧';
      case 'DE':
        return '🇩🇪';
      case 'FR':
        return '🇫🇷';
      case 'NL':
        return '🇳🇱';
      case 'CH':
        return '🇨🇭';
      case 'IT':
        return '🇮🇹';
      case 'ES':
        return '🇪🇸';
      case 'SE':
        return '🇸🇪';
      case 'NO':
        return '🇳🇴';
      case 'DK':
        return '🇩🇰';
      case 'FI':
        return '🇫🇮';
      case 'PL':
        return '🇵🇱';
      case 'IE':
        return '🇮🇪';
      case 'BE':
        return '🇧🇪';
      case 'AT':
        return '🇦🇹';
      case 'CZ':
        return '🇨🇿';
      case 'PT':
        return '🇵🇹';
      case 'GR':
        return '🇬🇷';
      case 'RO':
        return '🇷🇴';
      case 'HU':
        return '🇭🇺';
      case 'US':
        return '🇺🇸';
      case 'CA':
        return '🇨🇦';
      case 'MX':
        return '🇲🇽';
      case 'BR':
        return '🇧🇷';
      case 'AR':
        return '🇦🇷';
      case 'CL':
        return '🇨🇱';
      case 'CO':
        return '🇨🇴';
      case 'PE':
        return '🇵🇪';
      case 'JP':
        return '🇯🇵';
      case 'KR':
        return '🇰🇷';
      case 'CN':
        return '🇨🇳';
      case 'HK':
        return '🇭🇰';
      case 'TW':
        return '🇹🇼';
      case 'SG':
        return '🇸🇬';
      case 'MY':
        return '🇲🇾';
      case 'TH':
        return '🇹🇭';
      case 'VN':
        return '🇻🇳';
      case 'PH':
        return '🇵🇭';
      case 'ID':
        return '🇮🇩';
      case 'IN':
        return '🇮🇳';
      case 'PK':
        return '🇵🇰';
      case 'BD':
        return '🇧🇩';
      case 'AU':
        return '🇦🇺';
      case 'NZ':
        return '🇳🇿';
      case 'AE':
        return '🇦🇪';
      case 'SA':
        return '🇸🇦';
      case 'IL':
        return '🇮🇱';
      case 'TR':
        return '🇹🇷';
      case 'EG':
        return '🇪🇬';
      case 'ZA':
        return '🇿🇦';
      case 'NG':
        return '🇳🇬';
      case 'KE':
        return '🇰🇪';
      case 'MA':
        return '🇲🇦';
      case 'RU':
        return '🇷🇺';
      case 'UA':
        return '🇺🇦';
      case 'KZ':
        return '🇰🇿';

      default:
        return '🌍';
    }
  }

  static String getRegionContinent(String code) {
    switch (code.toUpperCase()) {
      case 'UK':
      case 'GB':
      case 'DE':
      case 'FR':
      case 'NL':
      case 'CH':
      case 'IT':
      case 'ES':
      case 'SE':
      case 'NO':
      case 'DK':
      case 'FI':
      case 'PL':
      case 'IE':
      case 'BE':
      case 'AT':
      case 'CZ':
      case 'PT':
      case 'GR':
      case 'RO':
      case 'HU':
        return 'Europe';

      case 'US':
      case 'CA':
      case 'MX':
        return 'North America';

      case 'BR':
      case 'AR':
      case 'CL':
      case 'CO':
      case 'PE':
        return 'South America';

      case 'JP':
      case 'KR':
      case 'CN':
      case 'HK':
      case 'TW':
      case 'SG':
      case 'MY':
      case 'TH':
      case 'VN':
      case 'PH':
      case 'ID':
      case 'IN':
      case 'PK':
      case 'BD':
        return 'Asia';

      case 'AU':
      case 'NZ':
        return 'Oceania';

      case 'AE':
      case 'SA':
      case 'IL':
      case 'TR':
      case 'EG':
        return 'Middle East';

      case 'ZA':
      case 'NG':
      case 'KE':
      case 'MA':
        return 'Africa';

      case 'RU':
      case 'UA':
      case 'KZ':
        return 'CIS';

      default:
        return 'Global';
    }
  }

  static List<String> getPopularRegions() {
    return ['US', 'UK', 'DE', 'JP', 'SG', 'AU', 'CA', 'HK'];
  }

  static List<String> getAllRegions() {
    return [
      'US', 'UK', 'DE', 'JP', 'SG', 'AU', 'CA', 'HK',
      'FR', 'NL', 'CH', 'IT', 'ES', 'SE', 'NO', 'DK', 'FI', 'PL', 'IE', 'BE', 'AT', 'CZ', 'PT', 'GR', 'RO', 'HU',
      'MX', 'BR', 'AR', 'CL', 'CO', 'PE',
      'KR', 'CN', 'TW', 'MY', 'TH', 'VN', 'PH', 'ID', 'IN', 'PK', 'BD',
      'NZ',
      'AE', 'SA', 'IL', 'TR', 'EG',
      'ZA', 'NG', 'KE', 'MA',
      'RU', 'UA', 'KZ',
    ];
  }
}