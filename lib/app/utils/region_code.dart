import 'package:flutter/material.dart';

class RegionCode {
  Map<String, String> countryCodeToRegionCode = {
    "+1": "US", // United States and Canada
    "+7": "RU", // Russia
    "+20": "EG", // Egypt
    "+30": "GR", // Greece
    "+31": "NL", // Netherlands
    "+32": "BE", // Belgium
    "+33": "FR", // France
    "+34": "ES", // Spain
    "+36": "HU", // Hungary
    "+39": "IT", // Italy
    "+40": "RO", // Romania
    "+41": "CH", // Switzerland
    "+43": "AT", // Austria
    "+44": "GB", // United Kingdom
    "+45": "DK", // Denmark
    "+46": "SE", // Sweden
    "+47": "NO", // Norway
    "+48": "PL", // Poland
    "+49": "DE", // Germany
    "+51": "PE", // Peru
    "+52": "MX", // Mexico
    "+53": "CU", // Cuba
    "+54": "AR", // Argentina
    "+55": "BR", // Brazil
    "+56": "CL", // Chile
    "+57": "CO", // Colombia
    "+58": "VE", // Venezuela
    "+60": "MY", // Malaysia
    "+61": "AU", // Australia
    "+62": "ID", // Indonesia
    "+63": "PH", // Philippines
    "+64": "NZ", // New Zealand
    "+65": "SG", // Singapore
    "+66": "TH", // Thailand
    "+81": "JP", // Japan
    "+82": "KR", // South Korea
    "+84": "VN", // Vietnam
    "+86": "CN", // China
    "+90": "TR", // Turkey
    "+91": "IN", // India
    "+92": "PK", // Pakistan
    "+93": "AF", // Afghanistan
    "+94": "LK", // Sri Lanka
    "+95": "MM", // Myanmar
    "+98": "IR", // Iran
    "+212": "MA", // Morocco
    "+213": "DZ", // Algeria
    "+216": "TN", // Tunisia
    "+234": "NG", // Nigeria
    "+250": "RW", // Rwanda
    "+254": "KE", // Kenya
    "+255": "TZ", // Tanzania
    "+256": "UG", // Uganda
    "+260": "ZM", // Zambia
    "+263": "ZW", // Zimbabwe
    "+27": "ZA", // South Africa
    "+357": "CY", // Cyprus
    "+358": "FI", // Finland
    "+370": "LT", // Lithuania
    "+371": "LV", // Latvia
    "+372": "EE", // Estonia
    "+380": "UA", // Ukraine
    "+381": "RS", // Serbia
    "+385": "HR", // Croatia
    "+386": "SI", // Slovenia
    "+387": "BA", // Bosnia and Herzegovina
    "+389": "MK", // North Macedonia
    "+971": "AE", // United Arab Emirates
    "+972": "IL", // Israel
    "+973": "BH", // Bahrain
    "+974": "QA", // Qatar
    "+975": "BT", // Bhutan
    "+977": "NP", // Nepal
  };

  String? getRegionCode(String phoneCode) {
    return countryCodeToRegionCode[phoneCode];
  }
}
