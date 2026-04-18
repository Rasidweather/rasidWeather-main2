// ignore_for_file: constant_identifier_names

class CountriesData {
  static const Map<String, Map<String, dynamic>> COUNTRIES_INFO = <String, Map<String, dynamic>>{


    // PART 1
// AD -> BF

    'AD': <String, dynamic>{
      'name': 'Andorra',
      'arabic_name': 'أندورا',
      'capital': 'Andorra la Vella',
      'timezone': 'Europe/Andorra',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 42.5063,
      'longitude': 1.5218,
      'flag': '🇦🇩'
    },
    'AE': <String, dynamic>{
      'name': 'United Arab Emirates',
      'arabic_name': 'الإمارات العربية المتحدة',
      'capital': 'Abu Dhabi',
      'timezone': 'Asia/Dubai',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': 24.4667,
      'longitude': 54.3667,
      'flag': '🇦🇪'
    },
    'AF': <String, dynamic>{
      'name': 'Afghanistan',
      'arabic_name': 'أفغانستان',
      'capital': 'Kabul',
      'timezone': 'Asia/Kabul',
      'gmtOffset': 4.5,
      'rawOffset': 4.5,
      'latitude': 34.5553,
      'longitude': 69.2075,
      'flag': '🇦🇫'
    },
    'AG': <String, dynamic>{
      'name': 'Antigua and Barbuda',
      'arabic_name': 'أنتيغوا وباربودا',
      'capital': "Saint John's",
      'timezone': 'America/Port_of_Spain', // or "America/Antigua" in some TZ databases
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 17.1274,
      'longitude': -61.8468,
      'flag': '🇦🇬'
    },
    'AI': <String, dynamic>{
      'name': 'Anguilla',
      'arabic_name': 'أنغويلا',
      'capital': 'The Valley',
      'timezone': 'America/Anguilla',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.2167,
      'longitude': -63.0500,
      'flag': '🇦🇮'
    },
    'AL': <String, dynamic>{
      'name': 'Albania',
      'arabic_name': 'ألبانيا',
      'capital': 'Tirana',
      'timezone': 'Europe/Tirane',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 41.3275,
      'longitude': 19.8187,
      'flag': '🇦🇱'
    },
    'AM': <String, dynamic>{
      'name': 'Armenia',
      'arabic_name': 'أرمينيا',
      'capital': 'Yerevan',
      'timezone': 'Asia/Yerevan',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': 40.1792,
      'longitude': 44.4991,
      'flag': '🇦🇲'
    },
    'AO': <String, dynamic>{
      'name': 'Angola',
      'arabic_name': 'أنغولا',
      'capital': 'Luanda',
      'timezone': 'Africa/Luanda',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': -8.8383,
      'longitude': 13.2344,
      'flag': '🇦🇴'
    },
    'AQ': <String, dynamic>{
      'name': 'Antarctica',
      'arabic_name': 'أنتاركتيكا',
      'capital': 'N/A',
      'timezone': 'Antarctica/Troll',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': -75.2509,
      'longitude': 0.0714,
      'flag': '🏳️'
    },
    'AR': <String, dynamic>{
      'name': 'Argentina',
      'arabic_name': 'الأرجنتين',
      'capital': 'Buenos Aires',
      'timezone': 'America/Argentina/Buenos_Aires',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': -34.6037,
      'longitude': -58.3816,
      'flag': '🇦🇷'
    },
    'AS': <String, dynamic>{
      'name': 'American Samoa',
      'arabic_name': 'ساموا الأمريكية',
      'capital': 'Pago Pago',
      'timezone': 'Pacific/Pago_Pago',
      'gmtOffset': -11,
      'rawOffset': -11,
      'latitude': -14.2756,
      'longitude': -170.7020,
      'flag': '🇦🇸'
    },
    'AT': <String, dynamic>{
      'name': 'Austria',
      'arabic_name': 'النمسا',
      'capital': 'Vienna',
      'timezone': 'Europe/Vienna',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 48.2082,
      'longitude': 16.3738,
      'flag': '🇦🇹'
    },
    'AU': <String, dynamic>{
      'name': 'Australia',
      'arabic_name': 'أستراليا',
      'capital': 'Canberra',
      'timezone': 'Australia/Sydney',
      // Many zones in Australia, but we pick the major east coast zone for the capital region.
      'gmtOffset': 10,
      'rawOffset': 10,
      'latitude': -35.2809,
      'longitude': 149.1300,
      'flag': '🇦🇺'
    },
    'AW': <String, dynamic>{
      'name': 'Aruba',
      'arabic_name': 'أروبا',
      'capital': 'Oranjestad',
      'timezone': 'America/Aruba',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 12.5090,
      'longitude': -70.0080,
      'flag': '🇦🇼'
    },
    'AX': <String, dynamic>{
      'name': 'Åland Islands',
      'arabic_name': 'جزر أولاند',
      'capital': 'Mariehamn',
      'timezone': 'Europe/Helsinki',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 60.1000,
      'longitude': 19.9500,
      'flag': '🇦🇽'
    },
    'AZ': <String, dynamic>{
      'name': 'Azerbaijan',
      'arabic_name': 'أذربيجان',
      'capital': 'Baku',
      'timezone': 'Asia/Baku',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': 40.4093,
      'longitude': 49.8671,
      'flag': '🇦🇿'
    },
    'BA': <String, dynamic>{
      'name': 'Bosnia and Herzegovina',
      'arabic_name': 'البوسنة والهرسك',
      'capital': 'Sarajevo',
      'timezone': 'Europe/Sarajevo',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 43.8563,
      'longitude': 18.4131,
      'flag': '🇧🇦'
    },
    'BB': <String, dynamic>{
      'name': 'Barbados',
      'arabic_name': 'بربادوس',
      'capital': 'Bridgetown',
      'timezone': 'America/Barbados',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 13.0975,
      'longitude': -59.6167,
      'flag': '🇧🇧'
    },
    'BD': <String, dynamic>{
      'name': 'Bangladesh',
      'arabic_name': 'بنغلاديش',
      'capital': 'Dhaka',
      'timezone': 'Asia/Dhaka',
      'gmtOffset': 6,
      'rawOffset': 6,
      'latitude': 23.8103,
      'longitude': 90.4125,
      'flag': '🇧🇩'
    },
    'BE': <String, dynamic>{
      'name': 'Belgium',
      'arabic_name': 'بلجيكا',
      'capital': 'Brussels',
      'timezone': 'Europe/Brussels',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 50.8503,
      'longitude': 4.3517,
      'flag': '🇧🇪'
    },
    'BF': <String, dynamic>{
      'name': 'Burkina Faso',
      'arabic_name': 'بوركينا فاسو',
      'capital': 'Ouagadougou',
      'timezone': 'Africa/Ouagadougou',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 12.3714,
      'longitude': -1.5197,
      'flag': '🇧🇫'
    },

    // PART 2
// BG -> BZ

    'BG': <String, dynamic>{
      'name': 'Bulgaria',
      'arabic_name': 'بلغاريا',
      'capital': 'Sofia',
      'timezone': 'Europe/Sofia',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 42.6977,
      'longitude': 23.3219,
      'flag': '🇧🇬'
    },
    'BH': <String, dynamic>{
      'name': 'Bahrain',
      'arabic_name': 'البحرين',
      'capital': 'Manama',
      'timezone': 'Asia/Bahrain',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 26.2167,
      'longitude': 50.5833,
      'flag': '🇧🇭'
    },
    'BI': <String, dynamic>{
      'name': 'Burundi',
      'arabic_name': 'بوروندي',
      'capital': 'Gitega',
      // Formerly Bujumbura was the largest city; Gitega is the political capital
      'timezone': 'Africa/Bujumbura',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -3.4264,
      'longitude': 29.9306,
      'flag': '🇧🇮'
    },
    'BJ': <String, dynamic>{
      'name': 'Benin',
      'arabic_name': 'بنين',
      'capital': 'Porto-Novo',
      'timezone': 'Africa/Porto-Novo',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 6.4969,
      'longitude': 2.6289,
      'flag': '🇧🇯'
    },
    'BL': <String, dynamic>{
      'name': 'Saint Barthélemy',
      'arabic_name': 'سان بارتيلمي',
      'capital': 'Gustavia',
      'timezone': 'America/St_Barthelemy',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 17.8964,
      'longitude': -62.8528,
      'flag': '🇧🇱'
    },
    'BM': <String, dynamic>{
      'name': 'Bermuda',
      'arabic_name': 'برمودا',
      'capital': 'Hamilton',
      'timezone': 'Atlantic/Bermuda',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 32.2948,
      'longitude': -64.7814,
      'flag': '🇧🇲'
    },
    'BN': <String, dynamic>{
      'name': 'Brunei',
      'arabic_name': 'بروناي',
      'capital': 'Bandar Seri Begawan',
      'timezone': 'Asia/Brunei',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 4.9031,
      'longitude': 114.9398,
      'flag': '🇧🇳'
    },
    'BO': <String, dynamic>{
      'name': 'Bolivia',
      'arabic_name': 'بوليفيا',
      'capital': 'La Paz (administrative), Sucre (constitutional)',
      'timezone': 'America/La_Paz',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': -16.4950,
      'longitude': -68.1334,
      'flag': '🇧🇴'
    },
    'BQ': <String, dynamic>{
      'name': 'Bonaire, Sint Eustatius and Saba',
      'arabic_name': 'بونير وسينت يوستاتيوس وسابا',
      'capital': 'Kralendijk (on Bonaire)',
      'timezone': 'America/Kralendijk',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 12.1443,
      'longitude': -68.2655,
      'flag': '🇧🇶'
    },
    'BR': <String, dynamic>{
      'name': 'Brazil',
      'arabic_name': 'البرازيل',
      'capital': 'Brasília',
      // Multiple time zones; using main capital region (UTC-3)
      'timezone': 'America/Sao_Paulo',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': -15.8267,
      'longitude': -47.9218,
      'flag': '🇧🇷'
    },
    'BS': <String, dynamic>{
      'name': 'The Bahamas',
      'arabic_name': 'الباهاماس',
      'capital': 'Nassau',
      'timezone': 'America/Nassau',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 25.0443,
      'longitude': -77.3504,
      'flag': '🇧🇸'
    },
    'BT': <String, dynamic>{
      'name': 'Bhutan',
      'arabic_name': 'بوتان',
      'capital': 'Thimphu',
      'timezone': 'Asia/Thimphu',
      'gmtOffset': 6,
      'rawOffset': 6,
      'latitude': 27.4728,
      'longitude': 89.6393,
      'flag': '🇧🇹'
    },
    'BV': <String, dynamic>{
      'name': 'Bouvet Island',
      'arabic_name': 'جزيرة بوفيه',
      'capital': 'N/A (uninhabited)',
      'timezone': 'Europe/Oslo',
      // Norwegian dependency, uninhabited
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': -54.4208,
      'longitude': 3.3464,
      'flag': '🏳️'
    },
    'BW': <String, dynamic>{
      'name': 'Botswana',
      'arabic_name': 'بوتسوانا',
      'capital': 'Gaborone',
      'timezone': 'Africa/Gaborone',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -24.6282,
      'longitude': 25.9231,
      'flag': '🇧🇼'
    },
    'BY': <String, dynamic>{
      'name': 'Belarus',
      'arabic_name': 'بيلاروسيا',
      'capital': 'Minsk',
      'timezone': 'Europe/Minsk',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 53.9007,
      'longitude': 27.5599,
      'flag': '🇧🇾'
    },
    'BZ': <String, dynamic>{
      'name': 'Belize',
      'arabic_name': 'بليز',
      'capital': 'Belmopan',
      'timezone': 'America/Belize',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 17.2511,
      'longitude': -88.7590,
      'flag': '🇧🇿'
    },

    // PART 3
// CA -> CZ

    'CA': <String, dynamic>{
      'name': 'Canada',
      'arabic_name': 'كندا',
      'capital': 'Ottawa',
      // Canada spans multiple time zones; we use Ottawa's zone (Eastern Time)
      'timezone': 'America/Toronto',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 45.4215,
      'longitude': -75.6972,
      'flag': '🇨🇦'
    },
    'CC': <String, dynamic>{
      'name': 'Cocos (Keeling) Islands',
      'arabic_name': 'جزر كوكوس (كيلينغ)',
      'capital': 'West Island',
      'timezone': 'Indian/Cocos',
      'gmtOffset': 6.5,
      'rawOffset': 6.5,
      'latitude': -12.0718,
      'longitude': 96.8709,
      'flag': '🇨🇨'
    },
    'CD': <String, dynamic>{
      'name': 'Democratic Republic of the Congo',
      'arabic_name': 'جمهورية الكونغو الديمقراطية',
      'capital': 'Kinshasa',
      // DRC spans multiple time zones; Kinshasa uses Africa/Kinshasa (UTC+1)
      'timezone': 'Africa/Kinshasa',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': -4.4419,
      'longitude': 15.2663,
      'flag': '🇨🇩'
    },
    'CF': <String, dynamic>{
      'name': 'Central African Republic',
      'arabic_name': 'جمهورية أفريقيا الوسطى',
      'capital': 'Bangui',
      'timezone': 'Africa/Bangui',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 4.3947,
      'longitude': 18.5582,
      'flag': '🇨🇫'
    },
    'CG': <String, dynamic>{
      'name': 'Republic of the Congo',
      'arabic_name': 'جمهورية الكونغو',
      'capital': 'Brazzaville',
      'timezone': 'Africa/Brazzaville',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': -4.2634,
      'longitude': 15.2429,
      'flag': '🇨🇬'
    },
    'CH': <String, dynamic>{
      'name': 'Switzerland',
      'arabic_name': 'سويسرا',
      'capital': 'Bern',
      'timezone': 'Europe/Zurich',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 46.9470,
      'longitude': 7.4474,
      'flag': '🇨🇭'
    },
    'CI': <String, dynamic>{
      'name': "Côte d'Ivoire",
      'arabic_name': 'ساحل العاج',
      'capital': 'Yamoussoukro',
      'timezone': 'Africa/Abidjan',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 6.8276,
      'longitude': -5.2893,
      'flag': '🇨🇮'
    },
    'CK': <String, dynamic>{
      'name': 'Cook Islands',
      'arabic_name': 'جزر كوك',
      'capital': 'Avarua',
      'timezone': 'Pacific/Rarotonga',
      'gmtOffset': -10,
      'rawOffset': -10,
      'latitude': -21.2129,
      'longitude': -159.7823,
      'flag': '🇨🇰'
    },
    'CL': <String, dynamic>{
      'name': 'Chile',
      'arabic_name': 'تشيلي',
      'capital': 'Santiago',
      // Chile has multiple time zones (Easter Island, etc.); we use America/Santiago (UTC-4 standard)
      'timezone': 'America/Santiago',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': -33.4489,
      'longitude': -70.6693,
      'flag': '🇨🇱'
    },
    'CM': <String, dynamic>{
      'name': 'Cameroon',
      'arabic_name': 'الكاميرون',
      'capital': 'Yaoundé',
      'timezone': 'Africa/Douala',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 3.8480,
      'longitude': 11.5021,
      'flag': '🇨🇲'
    },
    'CN': <String, dynamic>{
      'name': 'China',
      'arabic_name': 'الصين',
      'capital': 'Beijing',
      'timezone': 'Asia/Shanghai',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 39.9042,
      'longitude': 116.4074,
      'flag': '🇨🇳'
    },
    'CO': <String, dynamic>{
      'name': 'Colombia',
      'arabic_name': 'كولومبيا',
      'capital': 'Bogotá',
      'timezone': 'America/Bogota',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 4.7110,
      'longitude': -74.0721,
      'flag': '🇨🇴'
    },
    'CR': <String, dynamic>{
      'name': 'Costa Rica',
      'arabic_name': 'كوستاريكا',
      'capital': 'San José',
      'timezone': 'America/Costa_Rica',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 9.9281,
      'longitude': -84.0907,
      'flag': '🇨🇷'
    },
    'CU': <String, dynamic>{
      'name': 'Cuba',
      'arabic_name': 'كوبا',
      'capital': 'Havana',
      'timezone': 'America/Havana',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 23.1136,
      'longitude': -82.3666,
      'flag': '🇨🇺'
    },
    'CV': <String, dynamic>{
      'name': 'Cape Verde',
      'arabic_name': 'الرأس الأخضر',
      'capital': 'Praia',
      'timezone': 'Atlantic/Cape_Verde',
      'gmtOffset': -1,
      'rawOffset': -1,
      'latitude': 14.9330,
      'longitude': -23.5133,
      'flag': '🇨🇻'
    },
    'CW': <String, dynamic>{
      'name': 'Curaçao',
      'arabic_name': 'كوراساو',
      'capital': 'Willemstad',
      'timezone': 'America/Curacao',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 12.1224,
      'longitude': -68.8824,
      'flag': '🇨🇼'
    },
    'CX': <String, dynamic>{
      'name': 'Christmas Island',
      'arabic_name': 'جزيرة كريسماس',
      'capital': 'Flying Fish Cove',
      'timezone': 'Indian/Christmas',
      'gmtOffset': 7,
      'rawOffset': 7,
      'latitude': -10.4214,
      'longitude': 105.6797,
      'flag': '🇨🇽'
    },
    'CY': <String, dynamic>{
      'name': 'Cyprus',
      'arabic_name': 'قبرص',
      'capital': 'Nicosia',
      'timezone': 'Asia/Nicosia',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 35.1856,
      'longitude': 33.3823,
      'flag': '🇨🇾'
    },
    'CZ': <String, dynamic>{
      'name': 'Czechia', // or "Czech Republic"
      'arabic_name': 'التشيك',
      'capital': 'Prague',
      'timezone': 'Europe/Prague',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 50.0755,
      'longitude': 14.4378,
      'flag': '🇨🇿'
    },

// PART 4
// DE -> GH

    'DE': <String, dynamic>{
      'name': 'Germany',
      'arabic_name': 'ألمانيا',
      'capital': 'Berlin',
      'timezone': 'Europe/Berlin',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 52.5200,
      'longitude': 13.4050,
      'flag': '🇩🇪'
    },
    'DJ': <String, dynamic>{
      'name': 'Djibouti',
      'arabic_name': 'جيبوتي',
      'capital': 'Djibouti',
      'timezone': 'Africa/Djibouti',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 11.5721,
      'longitude': 43.1456,
      'flag': '🇩🇯'
    },
    'DK': <String, dynamic>{
      'name': 'Denmark',
      'arabic_name': 'الدنمارك',
      'capital': 'Copenhagen',
      'timezone': 'Europe/Copenhagen',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 55.6761,
      'longitude': 12.5683,
      'flag': '🇩🇰'
    },
    'DM': <String, dynamic>{
      'name': 'Dominica',
      'arabic_name': 'دومينيكا',
      'capital': 'Roseau',
      'timezone': 'America/Dominica',
      // Sometimes 'America/Port_of_Spain' used as a fallback
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 15.3017,
      'longitude': -61.3883,
      'flag': '🇩🇲'
    },
    'DO': <String, dynamic>{
      'name': 'Dominican Republic',
      'arabic_name': 'جمهورية الدومينيكان',
      'capital': 'Santo Domingo',
      'timezone': 'America/Santo_Domingo',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.4861,
      'longitude': -69.9312,
      'flag': '🇩🇴'
    },
    'DZ': <String, dynamic>{
      'name': 'Algeria',
      'arabic_name': 'الجزائر',
      'capital': 'Algiers',
      'timezone': 'Africa/Algiers',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 36.7538,
      'longitude': 3.0588,
      'flag': '🇩🇿'
    },
    'EC': <String, dynamic>{
      'name': 'Ecuador',
      'arabic_name': 'الإكوادور',
      'capital': 'Quito',
      'timezone': 'America/Guayaquil',
      // Galápagos Islands use UTC-6, but main city Quito is UTC-5
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': -0.1807,
      'longitude': -78.4678,
      'flag': '🇪🇨'
    },
    'EE': <String, dynamic>{
      'name': 'Estonia',
      'arabic_name': 'إستونيا',
      'capital': 'Tallinn',
      'timezone': 'Europe/Tallinn',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 59.4370,
      'longitude': 24.7536,
      'flag': '🇪🇪'
    },
    'EG': <String, dynamic>{
      'name': 'Egypt',
      'arabic_name': 'مصر',
      'capital': 'Cairo',
      'timezone': 'Africa/Cairo',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 30.0444,
      'longitude': 31.2357,
      'flag': '🇪🇬'
    },
    'EH': <String, dynamic>{
      'name': 'Western Sahara',
      'arabic_name': 'الصحراء الغربية',
      'capital': 'Laayoune (de facto)',
      'timezone': 'Africa/El_Aaiun',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 27.1253,
      'longitude': -13.1625,
      'flag': '🏴' // Often no official flag recognized by all, used Polisario or Morocco
    },
    'ER': <String, dynamic>{
      'name': 'Eritrea',
      'arabic_name': 'إريتريا',
      'capital': 'Asmara',
      'timezone': 'Africa/Asmara',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 15.3229,
      'longitude': 38.9251,
      'flag': '🇪🇷'
    },
    'ES': <String, dynamic>{
      'name': 'Spain',
      'arabic_name': 'إسبانيا',
      'capital': 'Madrid',
      'timezone': 'Europe/Madrid',
      // Spain also includes Canary Islands (UTC+0). Mainland is UTC+1 standard
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 40.4168,
      'longitude': -3.7038,
      'flag': '🇪🇸'
    },
    'ET': <String, dynamic>{
      'name': 'Ethiopia',
      'arabic_name': 'إثيوبيا',
      'capital': 'Addis Ababa',
      'timezone': 'Africa/Addis_Ababa',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 8.9806,
      'longitude': 38.7578,
      'flag': '🇪🇹'
    },
    'FI': <String, dynamic>{
      'name': 'Finland',
      'arabic_name': 'فنلندا',
      'capital': 'Helsinki',
      'timezone': 'Europe/Helsinki',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 60.1699,
      'longitude': 24.9384,
      'flag': '🇫🇮'
    },
    'FJ': <String, dynamic>{
      'name': 'Fiji',
      'arabic_name': 'فيجي',
      'capital': 'Suva',
      'timezone': 'Pacific/Fiji',
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': -18.1248,
      'longitude': 178.4501,
      'flag': '🇫🇯'
    },
    'FK': <String, dynamic>{
      'name': 'Falkland Islands',
      'arabic_name': 'جزر فوكلاند',
      'capital': 'Stanley',
      'timezone': 'Atlantic/Stanley',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': -51.6977,
      'longitude': -57.8517,
      'flag': '🇫🇰'
    },
    'FM': <String, dynamic>{
      'name': 'Federated States of Micronesia',
      'arabic_name': 'ميكرونيسيا',
      'capital': 'Palikir',
      // Multiple time zones for different islands. Palikir is in UTC+11
      'timezone': 'Pacific/Pohnpei',
      'gmtOffset': 11,
      'rawOffset': 11,
      'latitude': 6.9175,
      'longitude': 158.1850,
      'flag': '🇫🇲'
    },
    'FO': <String, dynamic>{
      'name': 'Faroe Islands',
      'arabic_name': 'جزر فارو',
      'capital': 'Tórshavn',
      'timezone': 'Atlantic/Faroe',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 62.0079,
      'longitude': -6.7900,
      'flag': '🇫🇴'
    },
    'FR': <String, dynamic>{
      'name': 'France',
      'arabic_name': 'فرنسا',
      'capital': 'Paris',
      'timezone': 'Europe/Paris',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 48.8566,
      'longitude': 2.3522,
      'flag': '🇫🇷'
    },
    'GA': <String, dynamic>{
      'name': 'Gabon',
      'arabic_name': 'الغابون',
      'capital': 'Libreville',
      'timezone': 'Africa/Libreville',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 0.4162,
      'longitude': 9.4673,
      'flag': '🇬🇦'
    },
    'GB': <String, dynamic>{
      'name': 'United Kingdom',
      'arabic_name': 'المملكة المتحدة',
      'capital': 'London',
      'timezone': 'Europe/London',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 51.5074,
      'longitude': -0.1278,
      'flag': '🇬🇧'
    },
    'GD': <String, dynamic>{
      'name': 'Grenada',
      'arabic_name': 'غرينادا',
      'capital': "St. George's",
      'timezone': 'America/Grenada',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 12.0561,
      'longitude': -61.7486,
      'flag': '🇬🇩'
    },
    'GE': <String, dynamic>{
      'name': 'Georgia',
      'arabic_name': 'جورجيا',
      'capital': 'Tbilisi',
      'timezone': 'Asia/Tbilisi',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': 41.7151,
      'longitude': 44.8271,
      'flag': '🇬🇪'
    },
    'GF': <String, dynamic>{
      'name': 'French Guiana',
      'arabic_name': 'غويانا الفرنسية',
      'capital': 'Cayenne',
      'timezone': 'America/Cayenne',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': 4.9224,
      'longitude': -52.3135,
      'flag': '🇬🇫'
    },
    'GG': <String, dynamic>{
      'name': 'Guernsey',
      'arabic_name': 'غيرنزي',
      'capital': 'St. Peter Port',
      'timezone': 'Europe/Guernsey',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 49.4541,
      'longitude': -2.5895,
      'flag': '🇬🇬'
    },
    'GH': <String, dynamic>{
      'name': 'Ghana',
      'arabic_name': 'غانا',
      'capital': 'Accra',
      'timezone': 'Africa/Accra',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 5.6037,
      'longitude': -0.1870,
      'flag': '🇬🇭'
    },
// PART 5
// GI -> LA

    'GI': <String, dynamic>{
      'name': 'Gibraltar',
      'arabic_name': 'جبل طارق',
      'capital': 'Gibraltar',
      'timezone': 'Europe/Gibraltar',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 36.1408,
      'longitude': -5.3536,
      'flag': '🇬🇮'
    },
    'GL': <String, dynamic>{
      'name': 'Greenland',
      'arabic_name': 'جرينلاند',
      'capital': 'Nuuk',
      // Multiple zones in Greenland; Nuuk is typically UTC-3 standard
      'timezone': 'America/Godthab',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': 64.1835,
      'longitude': -51.7216,
      'flag': '🇬🇱'
    },
    'GM': <String, dynamic>{
      'name': 'The Gambia',
      'arabic_name': 'غامبيا',
      'capital': 'Banjul',
      'timezone': 'Africa/Banjul',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 13.4549,
      'longitude': -16.5790,
      'flag': '🇬🇲'
    },
    'GN': <String, dynamic>{
      'name': 'Guinea',
      'arabic_name': 'غينيا',
      'capital': 'Conakry',
      'timezone': 'Africa/Conakry',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 9.6412,
      'longitude': -13.5784,
      'flag': '🇬🇳'
    },
    'GP': <String, dynamic>{
      'name': 'Guadeloupe',
      'arabic_name': 'جوادلوب',
      'capital': 'Basse-Terre',
      'timezone': 'America/Guadeloupe',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 16.2650,
      'longitude': -61.5500,
      'flag': '🇬🇵'
    },
    'GQ': <String, dynamic>{
      'name': 'Equatorial Guinea',
      'arabic_name': 'غينيا الاستوائية',
      'capital': 'Malabo',
      'timezone': 'Africa/Malabo',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 3.7500,
      'longitude': 8.7833,
      'flag': '🇬🇶'
    },
    'GR': <String, dynamic>{
      'name': 'Greece',
      'arabic_name': 'اليونان',
      'capital': 'Athens',
      'timezone': 'Europe/Athens',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 37.9838,
      'longitude': 23.7275,
      'flag': '🇬🇷'
    },
    'GS': <String, dynamic>{
      'name': 'South Georgia and the South Sandwich Islands',
      'arabic_name': 'جورجيا الجنوبية وجزر ساندويتش الجنوبية',
      'capital': 'King Edward Point',
      'timezone': 'Atlantic/South_Georgia',
      'gmtOffset': -2,
      'rawOffset': -2,
      'latitude': -54.2833,
      'longitude': -36.5000,
      'flag': '🇬🇸'
    },
    'GT': <String, dynamic>{
      'name': 'Guatemala',
      'arabic_name': 'غواتيمالا',
      'capital': 'Guatemala City',
      'timezone': 'America/Guatemala',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 14.6349,
      'longitude': -90.5069,
      'flag': '🇬🇹'
    },
    'GU': <String, dynamic>{
      'name': 'Guam',
      'arabic_name': 'غوام',
      'capital': 'Hagåtña',
      'timezone': 'Pacific/Guam',
      'gmtOffset': 10,
      'rawOffset': 10,
      'latitude': 13.4710,
      'longitude': 144.7850,
      'flag': '🇬🇺'
    },
    'GW': <String, dynamic>{
      'name': 'Guinea-Bissau',
      'arabic_name': 'غينيا بيساو',
      'capital': 'Bissau',
      'timezone': 'Africa/Bissau',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 11.8596,
      'longitude': -15.5875,
      'flag': '🇬🇼'
    },
    'GY': <String, dynamic>{
      'name': 'Guyana',
      'arabic_name': 'غيانا',
      'capital': 'Georgetown',
      'timezone': 'America/Guyana',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 6.8013,
      'longitude': -58.1551,
      'flag': '🇬🇾'
    },
    'HK': <String, dynamic>{
      'name': 'Hong Kong',
      'arabic_name': 'هونغ كونغ',
      'capital': 'Hong Kong',
      'timezone': 'Asia/Hong_Kong',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 22.3193,
      'longitude': 114.1694,
      'flag': '🇭🇰'
    },
    'HM': <String, dynamic>{
      'name': 'Heard Island and McDonald Islands',
      'arabic_name': 'جزيرة هيرد وجزر ماكدونالد',
      'capital': 'N/A (uninhabited)',
      'timezone': 'Indian/Kerguelen',
      // Often grouped with French Southern Territories, effectively UTC+5
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': -53.0818,
      'longitude': 73.5042,
      'flag': '🏳️'
    },
    'HN': <String, dynamic>{
      'name': 'Honduras',
      'arabic_name': 'هندوراس',
      'capital': 'Tegucigalpa',
      'timezone': 'America/Tegucigalpa',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 14.0723,
      'longitude': -87.1921,
      'flag': '🇭🇳'
    },
    'HR': <String, dynamic>{
      'name': 'Croatia',
      'arabic_name': 'كرواتيا',
      'capital': 'Zagreb',
      'timezone': 'Europe/Zagreb',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 45.8150,
      'longitude': 15.9819,
      'flag': '🇭🇷'
    },
    'HT': <String, dynamic>{
      'name': 'Haiti',
      'arabic_name': 'هايتي',
      'capital': 'Port-au-Prince',
      'timezone': 'America/Port-au-Prince',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 18.5944,
      'longitude': -72.3074,
      'flag': '🇭🇹'
    },
    'HU': <String, dynamic>{
      'name': 'Hungary',
      'arabic_name': 'المجر',
      'capital': 'Budapest',
      'timezone': 'Europe/Budapest',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 47.4979,
      'longitude': 19.0402,
      'flag': '🇭🇺'
    },
    'ID': <String, dynamic>{
      'name': 'Indonesia',
      'arabic_name': 'إندونيسيا',
      'capital': 'Jakarta',
      // Indonesia spans multiple zones; Jakarta is typically Asia/Jakarta (UTC+7)
      'timezone': 'Asia/Jakarta',
      'gmtOffset': 7,
      'rawOffset': 7,
      'latitude': -6.2088,
      'longitude': 106.8456,
      'flag': '🇮🇩'
    },
    'IE': <String, dynamic>{
      'name': 'Ireland',
      'arabic_name': 'أيرلندا',
      'capital': 'Dublin',
      'timezone': 'Europe/Dublin',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 53.3498,
      'longitude': -6.2603,
      'flag': '🇮🇪'
    },
    'IL': <String, dynamic>{
      'name': 'Israel',
      'arabic_name': 'إسرائيل',
      'capital': 'Jerusalem',
      'timezone': 'Asia/Jerusalem',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 31.7683,
      'longitude': 35.2137,
      'flag': '🇮🇱'
    },
    'IM': <String, dynamic>{
      'name': 'Isle of Man',
      'arabic_name': 'جزيرة مان',
      'capital': 'Douglas',
      'timezone': 'Europe/Isle_of_Man',
      // Some systems just use Europe/London, effectively
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 54.1523,
      'longitude': -4.4861,
      'flag': '🇮🇲'
    },
    'IN': <String, dynamic>{
      'name': 'India',
      'arabic_name': 'الهند',
      'capital': 'New Delhi',
      'timezone': 'Asia/Kolkata',
      'gmtOffset': 5.5,
      'rawOffset': 5.5,
      'latitude': 28.6139,
      'longitude': 77.2090,
      'flag': '🇮🇳'
    },
    'IO': <String, dynamic>{
      'name': 'British Indian Ocean Territory',
      'arabic_name': 'إقليم المحيط الهندي البريطاني',
      'capital': 'Diego Garcia',
      'timezone': 'Indian/Chagos',
      'gmtOffset': 6,
      'rawOffset': 6,
      'latitude': -7.3138,
      'longitude': 72.4220,
      'flag': '🇮🇴'
    },
    'IQ': <String, dynamic>{
      'name': 'Iraq',
      'arabic_name': 'العراق',
      'capital': 'Baghdad',
      'timezone': 'Asia/Baghdad',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 33.3152,
      'longitude': 44.3661,
      'flag': '🇮🇶'
    },
    'IR': <String, dynamic>{
      'name': 'Iran',
      'arabic_name': 'إيران',
      'capital': 'Tehran',
      'timezone': 'Asia/Tehran',
      // Iran observes UTC+3:30 standard, +4:30 in DST. We'll use standard offset
      'gmtOffset': 3.5,
      'rawOffset': 3.5,
      'latitude': 35.6892,
      'longitude': 51.3890,
      'flag': '🇮🇷'
    },
    'IS': <String, dynamic>{
      'name': 'Iceland',
      'arabic_name': 'آيسلندا',
      'capital': 'Reykjavik',
      'timezone': 'Atlantic/Reykjavik',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 64.1466,
      'longitude': -21.9426,
      'flag': '🇮🇸'
    },
    'IT': <String, dynamic>{
      'name': 'Italy',
      'arabic_name': 'إيطاليا',
      'capital': 'Rome',
      'timezone': 'Europe/Rome',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 41.9028,
      'longitude': 12.4964,
      'flag': '🇮🇹'
    },
    'JE': <String, dynamic>{
      'name': 'Jersey',
      'arabic_name': 'جيرزي',
      'capital': 'Saint Helier',
      'timezone': 'Europe/Jersey',
      // Some systems just use Europe/London
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 49.1828,
      'longitude': -2.1068,
      'flag': '🇯🇪'
    },
    'JM': <String, dynamic>{
      'name': 'Jamaica',
      'arabic_name': 'جامايكا',
      'capital': 'Kingston',
      'timezone': 'America/Jamaica',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 17.9714,
      'longitude': -76.7923,
      'flag': '🇯🇲'
    },
    'JO': <String, dynamic>{
      'name': 'Jordan',
      'arabic_name': 'الأردن',
      'capital': 'Amman',
      'timezone': 'Asia/Amman',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 31.9522,
      'longitude': 35.9334,
      'flag': '🇯🇴'
    },
    'JP': <String, dynamic>{
      'name': 'Japan',
      'arabic_name': 'اليابان',
      'capital': 'Tokyo',
      'timezone': 'Asia/Tokyo',
      'gmtOffset': 9,
      'rawOffset': 9,
      'latitude': 35.6895,
      'longitude': 139.6917,
      'flag': '🇯🇵'
    },
    'KE': <String, dynamic>{
      'name': 'Kenya',
      'arabic_name': 'كينيا',
      'capital': 'Nairobi',
      'timezone': 'Africa/Nairobi',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': -1.2864,
      'longitude': 36.8172,
      'flag': '🇰🇪'
    },
    'KG': <String, dynamic>{
      'name': 'Kyrgyzstan',
      'arabic_name': 'قيرغيزستان',
      'capital': 'Bishkek',
      'timezone': 'Asia/Bishkek',
      'gmtOffset': 6,
      'rawOffset': 6,
      'latitude': 42.8746,
      'longitude': 74.5698,
      'flag': '🇰🇬'
    },
    'KH': <String, dynamic>{
      'name': 'Cambodia',
      'arabic_name': 'كمبوديا',
      'capital': 'Phnom Penh',
      'timezone': 'Asia/Phnom_Penh',
      'gmtOffset': 7,
      'rawOffset': 7,
      'latitude': 11.5564,
      'longitude': 104.9282,
      'flag': '🇰🇭'
    },
    'KI': <String, dynamic>{
      'name': 'Kiribati',
      'arabic_name': 'كيريباتي',
      'capital': 'Tarawa',
      // Kiribati has multiple zones: UTC+12, UTC+13, UTC+14. Tarawa is UTC+12
      'timezone': 'Pacific/Tarawa',
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': 1.3290,
      'longitude': 173.0091,
      'flag': '🇰🇮'
    },
    'KM': <String, dynamic>{
      'name': 'Comoros',
      'arabic_name': 'جزر القمر',
      'capital': 'Moroni',
      'timezone': 'Indian/Comoro',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': -11.6986,
      'longitude': 43.2539,
      'flag': '🇰🇲'
    },
    'KN': <String, dynamic>{
      'name': 'Saint Kitts and Nevis',
      'arabic_name': 'سانت كيتس ونيفيس',
      'capital': 'Basseterre',
      'timezone': 'America/St_Kitts',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 17.3026,
      'longitude': -62.7177,
      'flag': '🇰🇳'
    },
    'KP': <String, dynamic>{
      'name': 'North Korea',
      'arabic_name': 'كوريا الشمالية',
      'capital': 'Pyongyang',
      'timezone': 'Asia/Pyongyang',
      'gmtOffset': 9,
      'rawOffset': 9,
      'latitude': 39.0392,
      'longitude': 125.7625,
      'flag': '🇰🇵'
    },
    'KR': <String, dynamic>{
      'name': 'South Korea',
      'arabic_name': 'كوريا الجنوبية',
      'capital': 'Seoul',
      'timezone': 'Asia/Seoul',
      'gmtOffset': 9,
      'rawOffset': 9,
      'latitude': 37.5665,
      'longitude': 126.9780,
      'flag': '🇰🇷'
    },
    'KW': <String, dynamic>{
      'name': 'Kuwait',
      'arabic_name': 'الكويت',
      'capital': 'Kuwait City',
      'timezone': 'Asia/Kuwait',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 29.3759,
      'longitude': 47.9774,
      'flag': '🇰🇼'
    },
    'KY': <String, dynamic>{
      'name': 'Cayman Islands',
      'arabic_name': 'جزر كايمان',
      'capital': 'George Town',
      'timezone': 'America/Cayman',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 19.2869,
      'longitude': -81.3674,
      'flag': '🇰🇾'
    },
    'KZ': <String, dynamic>{
      'name': 'Kazakhstan',
      'arabic_name': 'كازاخستان',
      'capital': 'Astana (Nur-Sultan)',
      // Kazakhstan spans multiple zones, capital is in Asia/Almaty or Asia/Qostanay or Asia/Aqtobe,
      // but official seat moved to Astana region, typically UTC+6
      'timezone': 'Asia/Almaty',
      'gmtOffset': 6,
      'rawOffset': 6,
      'latitude': 51.1801,
      'longitude': 71.4460,
      'flag': '🇰🇿'
    },
    'LA': <String, dynamic>{
      'name': 'Laos',
      'arabic_name': 'لاوس',
      'capital': 'Vientiane',
      'timezone': 'Asia/Vientiane',
      'gmtOffset': 7,
      'rawOffset': 7,
      'latitude': 17.9757,
      'longitude': 102.6331,
      'flag': '🇱🇦'
    },

// PART 6
// LB -> MZ

    'LB': <String, dynamic>{
      'name': 'Lebanon',
      'arabic_name': 'لبنان',
      'capital': 'Beirut',
      'timezone': 'Asia/Beirut',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 33.8938,
      'longitude': 35.5018,
      'flag': '🇱🇧'
    },
    'LC': <String, dynamic>{
      'name': 'Saint Lucia',
      'arabic_name': 'سانت لوسيا',
      'capital': 'Castries',
      'timezone': 'America/St_Lucia',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 14.0101,
      'longitude': -60.9875,
      'flag': '🇱🇨'
    },
    'LI': <String, dynamic>{
      'name': 'Liechtenstein',
      'arabic_name': 'ليختنشتاين',
      'capital': 'Vaduz',
      'timezone': 'Europe/Vaduz',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 47.1415,
      'longitude': 9.5215,
      'flag': '🇱🇮'
    },
    'LK': <String, dynamic>{
      'name': 'Sri Lanka',
      'arabic_name': 'سريلانكا',
      'capital': 'Colombo',
      'timezone': 'Asia/Colombo',
      'gmtOffset': 5.5,
      'rawOffset': 5.5,
      'latitude': 6.9271,
      'longitude': 79.8612,
      'flag': '🇱🇰'
    },
    'LR': <String, dynamic>{
      'name': 'Liberia',
      'arabic_name': 'ليبيريا',
      'capital': 'Monrovia',
      'timezone': 'Africa/Monrovia',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 6.3156,
      'longitude': -10.8072,
      'flag': '🇱🇷'
    },
    'LS': <String, dynamic>{
      'name': 'Lesotho',
      'arabic_name': 'ليسوتو',
      'capital': 'Maseru',
      'timezone': 'Africa/Maseru',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -29.3142,
      'longitude': 27.4833,
      'flag': '🇱🇸'
    },
    'LT': <String, dynamic>{
      'name': 'Lithuania',
      'arabic_name': 'ليتوانيا',
      'capital': 'Vilnius',
      'timezone': 'Europe/Vilnius',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 54.6872,
      'longitude': 25.2797,
      'flag': '🇱🇹'
    },
    'LU': <String, dynamic>{
      'name': 'Luxembourg',
      'arabic_name': 'لوكسمبورغ',
      'capital': 'Luxembourg',
      'timezone': 'Europe/Luxembourg',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 49.6116,
      'longitude': 6.1319,
      'flag': '🇱🇺'
    },
    'LV': <String, dynamic>{
      'name': 'Latvia',
      'arabic_name': 'لاتفيا',
      'capital': 'Riga',
      'timezone': 'Europe/Riga',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 56.9496,
      'longitude': 24.1052,
      'flag': '🇱🇻'
    },
    'LY': <String, dynamic>{
      'name': 'Libya',
      'arabic_name': 'ليبيا',
      'capital': 'Tripoli',
      'timezone': 'Africa/Tripoli',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 32.8872,
      'longitude': 13.1913,
      'flag': '🇱🇾'
    },
    'MA': <String, dynamic>{
      'name': 'Morocco',
      'arabic_name': 'المغرب',
      'capital': 'Rabat',
      'timezone': 'Africa/Casablanca',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 34.0209,
      'longitude': -6.8416,
      'flag': '🇲🇦'
    },
    'MC': <String, dynamic>{
      'name': 'Monaco',
      'arabic_name': 'موناكو',
      'capital': 'Monaco',
      'timezone': 'Europe/Monaco',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 43.7384,
      'longitude': 7.4246,
      'flag': '🇲🇨'
    },
    'MD': <String, dynamic>{
      'name': 'Moldova',
      'arabic_name': 'مولدوفا',
      'capital': 'Chișinău',
      'timezone': 'Europe/Chisinau',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 47.0105,
      'longitude': 28.8638,
      'flag': '🇲🇩'
    },
    'ME': <String, dynamic>{
      'name': 'Montenegro',
      'arabic_name': 'الجبل الأسود',
      'capital': 'Podgorica',
      'timezone': 'Europe/Podgorica',
      // sometimes Europe's data calls it Europe/Belgrade
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 42.4304,
      'longitude': 19.2594,
      'flag': '🇲🇪'
    },
    'MF': <String, dynamic>{
      'name': 'Saint Martin (French part)',
      'arabic_name': 'سان مارتين (الجزء الفرنسي)',
      'capital': 'Marigot',
      'timezone': 'America/Marigot',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.0669,
      'longitude': -63.0501,
      'flag': '🇲🇫'
    },
    'MG': <String, dynamic>{
      'name': 'Madagascar',
      'arabic_name': 'مدغشقر',
      'capital': 'Antananarivo',
      'timezone': 'Indian/Antananarivo',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': -18.8792,
      'longitude': 47.5079,
      'flag': '🇲🇬'
    },
    'MH': <String, dynamic>{
      'name': 'Marshall Islands',
      'arabic_name': 'جزر مارشال',
      'capital': 'Majuro',
      'timezone': 'Pacific/Majuro',
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': 7.1164,
      'longitude': 171.1854,
      'flag': '🇲🇭'
    },
    'MK': <String, dynamic>{
      'name': 'North Macedonia',
      'arabic_name': 'مقدونيا الشمالية',
      'capital': 'Skopje',
      'timezone': 'Europe/Skopje',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 41.9973,
      'longitude': 21.4280,
      'flag': '🇲🇰'
    },
    'ML': <String, dynamic>{
      'name': 'Mali',
      'arabic_name': 'مالي',
      'capital': 'Bamako',
      'timezone': 'Africa/Bamako',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 12.6392,
      'longitude': -8.0029,
      'flag': '🇲🇱'
    },
    'MM': <String, dynamic>{
      'name': 'Myanmar',
      'arabic_name': 'ميانمار',
      'capital': 'Naypyidaw',
      'timezone': 'Asia/Yangon',
      'gmtOffset': 6.5,
      'rawOffset': 6.5,
      'latitude': 19.7633,
      'longitude': 96.0785,
      'flag': '🇲🇲'
    },
    'MN': <String, dynamic>{
      'name': 'Mongolia',
      'arabic_name': 'منغوليا',
      'capital': 'Ulaanbaatar',
      'timezone': 'Asia/Ulaanbaatar',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 47.9167,
      'longitude': 106.9172,
      'flag': '🇲🇳'
    },
    'MO': <String, dynamic>{
      'name': 'Macau',
      'arabic_name': 'ماكاو',
      'capital': 'Macau',
      'timezone': 'Asia/Macau',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 22.1987,
      'longitude': 113.5439,
      'flag': '🇲🇴'
    },
    'MP': <String, dynamic>{
      'name': 'Northern Mariana Islands',
      'arabic_name': 'جزر ماريانا الشمالية',
      'capital': 'Saipan',
      'timezone': 'Pacific/Saipan',
      'gmtOffset': 10,
      'rawOffset': 10,
      'latitude': 15.1850,
      'longitude': 145.7467,
      'flag': '🇲🇵'
    },
    'MQ': <String, dynamic>{
      'name': 'Martinique',
      'arabic_name': 'مارتينيك',
      'capital': 'Fort-de-France',
      'timezone': 'America/Martinique',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 14.6161,
      'longitude': -61.0588,
      'flag': '🇲🇶'
    },
    'MR': <String, dynamic>{
      'name': 'Mauritania',
      'arabic_name': 'موريتانيا',
      'capital': 'Nouakchott',
      'timezone': 'Africa/Nouakchott',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 18.0735,
      'longitude': -15.9582,
      'flag': '🇲🇷'
    },
    'MS': <String, dynamic>{
      'name': 'Montserrat',
      'arabic_name': 'مونتسيرات',
      'capital': 'Plymouth (de jure), Brades (de facto)',
      'timezone': 'America/Montserrat',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 16.7065,
      'longitude': -62.2159,
      'flag': '🇲🇸'
    },
    'MT': <String, dynamic>{
      'name': 'Malta',
      'arabic_name': 'مالطا',
      'capital': 'Valletta',
      'timezone': 'Europe/Malta',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 35.8989,
      'longitude': 14.5146,
      'flag': '🇲🇹'
    },
    'MU': <String, dynamic>{
      'name': 'Mauritius',
      'arabic_name': 'موريشيوس',
      'capital': 'Port Louis',
      'timezone': 'Indian/Mauritius',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': -20.1609,
      'longitude': 57.5012,
      'flag': '🇲🇺'
    },
    'MV': <String, dynamic>{
      'name': 'Maldives',
      'arabic_name': 'جزر المالديف',
      'capital': 'Malé',
      'timezone': 'Indian/Maldives',
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': 4.1755,
      'longitude': 73.5093,
      'flag': '🇲🇻'
    },
    'MW': <String, dynamic>{
      'name': 'Malawi',
      'arabic_name': 'مالاوي',
      'capital': 'Lilongwe',
      'timezone': 'Africa/Blantyre',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -13.9626,
      'longitude': 33.7741,
      'flag': '🇲🇼'
    },
    'MX': <String, dynamic>{
      'name': 'Mexico',
      'arabic_name': 'المكسيك',
      'capital': 'Mexico City',
      // Mexico has multiple zones; capital is in America/Mexico_City (UTC-6 standard)
      'timezone': 'America/Mexico_City',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 19.4326,
      'longitude': -99.1332,
      'flag': '🇲🇽'
    },
    'MY': <String, dynamic>{
      'name': 'Malaysia',
      'arabic_name': 'ماليزيا',
      'capital': 'Kuala Lumpur',
      // administrative capital is Putrajaya, but commonly KL is used
      'timezone': 'Asia/Kuala_Lumpur',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 3.1390,
      'longitude': 101.6869,
      'flag': '🇲🇾'
    },
    'MZ': <String, dynamic>{
      'name': 'Mozambique',
      'arabic_name': 'موزمبيق',
      'capital': 'Maputo',
      'timezone': 'Africa/Maputo',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -25.9667,
      'longitude': 32.5833,
      'flag': '🇲🇿'
    },
// PART 7
// NA -> OM

    'NA': <String, dynamic>{
      'name': 'Namibia',
      'arabic_name': 'ناميبيا',
      'capital': 'Windhoek',
      'timezone': 'Africa/Windhoek',
      // Namibia sometimes observes DST, but standard offset is UTC+2
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -22.5609,
      'longitude': 17.0658,
      'flag': '🇳🇦'
    },
    'NC': <String, dynamic>{
      'name': 'New Caledonia',
      'arabic_name': 'كاليدونيا الجديدة',
      'capital': 'Nouméa',
      'timezone': 'Pacific/Noumea',
      'gmtOffset': 11,
      'rawOffset': 11,
      'latitude': -22.2758,
      'longitude': 166.4580,
      'flag': '🇳🇨'
    },
    'NE': <String, dynamic>{
      'name': 'Niger',
      'arabic_name': 'النيجر',
      'capital': 'Niamey',
      'timezone': 'Africa/Niamey',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 13.5116,
      'longitude': 2.1254,
      'flag': '🇳🇪'
    },
    'NF': <String, dynamic>{
      'name': 'Norfolk Island',
      'arabic_name': 'جزيرة نورفولك',
      'capital': 'Kingston',
      'timezone': 'Pacific/Norfolk',
      'gmtOffset': 11,
      'rawOffset': 11,
      'latitude': -29.0564,
      'longitude': 167.9590,
      'flag': '🇳🇫'
    },
    'NG': <String, dynamic>{
      'name': 'Nigeria',
      'arabic_name': 'نيجيريا',
      'capital': 'Abuja',
      'timezone': 'Africa/Lagos',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 9.0765,
      'longitude': 7.3986,
      'flag': '🇳🇬'
    },
    'NI': <String, dynamic>{
      'name': 'Nicaragua',
      'arabic_name': 'نيكاراغوا',
      'capital': 'Managua',
      'timezone': 'America/Managua',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 12.1140,
      'longitude': -86.2362,
      'flag': '🇳🇮'
    },
    'NL': <String, dynamic>{
      'name': 'Netherlands',
      'arabic_name': 'هولندا',
      'capital': 'Amsterdam',
      'timezone': 'Europe/Amsterdam',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 52.3676,
      'longitude': 4.9041,
      'flag': '🇳🇱'
    },
    'NO': <String, dynamic>{
      'name': 'Norway',
      'arabic_name': 'النرويج',
      'capital': 'Oslo',
      'timezone': 'Europe/Oslo',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 59.9139,
      'longitude': 10.7522,
      'flag': '🇳🇴'
    },
    'NP': <String, dynamic>{
      'name': 'Nepal',
      'arabic_name': 'نيبال',
      'capital': 'Kathmandu',
      'timezone': 'Asia/Kathmandu',
      // Nepal uses UTC+5:45
      'gmtOffset': 5.75,
      'rawOffset': 5.75,
      'latitude': 27.7172,
      'longitude': 85.3240,
      'flag': '🇳🇵'
    },
    'NR': <String, dynamic>{
      'name': 'Nauru',
      'arabic_name': 'ناورو',
      'capital': 'Yaren (de facto)',
      'timezone': 'Pacific/Nauru',
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': -0.5477,
      'longitude': 166.9209,
      'flag': '🇳🇷'
    },
    'NU': <String, dynamic>{
      'name': 'Niue',
      'arabic_name': 'نيوي',
      'capital': 'Alofi',
      'timezone': 'Pacific/Niue',
      'gmtOffset': -11,
      'rawOffset': -11,
      'latitude': -19.0544,
      'longitude': -169.8672,
      'flag': '🇳🇺'
    },
    'NZ': <String, dynamic>{
      'name': 'New Zealand',
      'arabic_name': 'نيوزيلندا',
      'capital': 'Wellington',
      'timezone': 'Pacific/Auckland',
      // Standard offset is UTC+12, UTC+13 in DST. We'll use +12 as raw offset
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': -41.2866,
      'longitude': 174.7756,
      'flag': '🇳🇿'
    },
    'OM': <String, dynamic>{
      'name': 'Oman',
      'arabic_name': 'عُمان',
      'capital': 'Muscat',
      'timezone': 'Asia/Muscat',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': 23.5880,
      'longitude': 58.3829,
      'flag': '🇴🇲'
    },

// PART 8
// PA -> RS

    'PA': <String, dynamic>{
      'name': 'Panama',
      'arabic_name': 'بنما',
      'capital': 'Panama City',
      'timezone': 'America/Panama',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 8.9833,
      'longitude': -79.5167,
      'flag': '🇵🇦'
    },
    'PE': <String, dynamic>{
      'name': 'Peru',
      'arabic_name': 'بيرو',
      'capital': 'Lima',
      'timezone': 'America/Lima',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': -12.0464,
      'longitude': -77.0428,
      'flag': '🇵🇪'
    },
    'PF': <String, dynamic>{
      'name': 'French Polynesia',
      'arabic_name': 'بولينيزيا الفرنسية',
      'capital': 'Papeete',
      'timezone': 'Pacific/Tahiti',
      'gmtOffset': -10,
      'rawOffset': -10,
      'latitude': -17.6509,
      'longitude': -149.4260,
      'flag': '🇵🇫'
    },
    'PG': <String, dynamic>{
      'name': 'Papua New Guinea',
      'arabic_name': 'بابوا غينيا الجديدة',
      'capital': 'Port Moresby',
      'timezone': 'Pacific/Port_Moresby',
      'gmtOffset': 10,
      'rawOffset': 10,
      'latitude': -9.4438,
      'longitude': 147.1803,
      'flag': '🇵🇬'
    },
    'PH': <String, dynamic>{
      'name': 'Philippines',
      'arabic_name': 'الفلبين',
      'capital': 'Manila',
      'timezone': 'Asia/Manila',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 14.5995,
      'longitude': 120.9842,
      'flag': '🇵🇭'
    },
    'PK': <String, dynamic>{
      'name': 'Pakistan',
      'arabic_name': 'باكستان',
      'capital': 'Islamabad',
      'timezone': 'Asia/Karachi',
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': 33.7294,
      'longitude': 73.0931,
      'flag': '🇵🇰'
    },
    'PL': <String, dynamic>{
      'name': 'Poland',
      'arabic_name': 'بولندا',
      'capital': 'Warsaw',
      'timezone': 'Europe/Warsaw',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 52.2297,
      'longitude': 21.0122,
      'flag': '🇵🇱'
    },
    'PM': <String, dynamic>{
      'name': 'Saint Pierre and Miquelon',
      'arabic_name': 'سان بيير وميكلون',
      'capital': 'Saint-Pierre',
      'timezone': 'America/Miquelon',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': 46.7758,
      'longitude': -56.1800,
      'flag': '🇵🇲'
    },
    'PN': <String, dynamic>{
      'name': 'Pitcairn Islands',
      'arabic_name': 'جزر بيتكيرن',
      'capital': 'Adamstown',
      'timezone': 'Pacific/Pitcairn',
      'gmtOffset': -8,
      'rawOffset': -8,
      'latitude': -25.0660,
      'longitude': -130.1000,
      'flag': '🇵🇳'
    },
    'PR': <String, dynamic>{
      'name': 'Puerto Rico',
      'arabic_name': 'بورتوريكو',
      'capital': 'San Juan',
      'timezone': 'America/Puerto_Rico',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.4655,
      'longitude': -66.1057,
      'flag': '🇵🇷'
    },
    'PS': <String, dynamic>{
      'name': 'Palestine',
      'arabic_name': 'فلسطين',
      'capital': 'Jerusalem',
      // Commonly used time zone references: "Asia/Gaza" or "Asia/Hebron"
      'timezone': 'Asia/Gaza',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 31.9522,
      'longitude': 35.2332,
      'flag': '🇵🇸'
    },
    'PT': <String, dynamic>{
      'name': 'Portugal',
      'arabic_name': 'البرتغال',
      'capital': 'Lisbon',
      'timezone': 'Europe/Lisbon',
      // Mainland Portugal is UTC+0 standard, the Azores is UTC-1
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 38.7223,
      'longitude': -9.1393,
      'flag': '🇵🇹'
    },
    'PW': <String, dynamic>{
      'name': 'Palau',
      'arabic_name': 'بالاو',
      'capital': 'Ngerulmud',
      'timezone': 'Pacific/Palau',
      'gmtOffset': 9,
      'rawOffset': 9,
      'latitude': 7.5004,
      'longitude': 134.6243,
      'flag': '🇵🇼'
    },
    'PY': <String, dynamic>{
      'name': 'Paraguay',
      'arabic_name': 'باراغواي',
      'capital': 'Asunción',
      'timezone': 'America/Asuncion',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': -25.2637,
      'longitude': -57.5759,
      'flag': '🇵🇾'
    },
    'QA': <String, dynamic>{
      'name': 'Qatar',
      'arabic_name': 'قطر',
      'capital': 'Doha',
      'timezone': 'Asia/Qatar',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 25.2867,
      'longitude': 51.5333,
      'flag': '🇶🇦'
    },
    'RE': <String, dynamic>{
      'name': 'Réunion',
      'arabic_name': 'لا ريونيون',
      'capital': 'Saint-Denis',
      'timezone': 'Indian/Reunion',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': -20.8789,
      'longitude': 55.4482,
      'flag': '🇷🇪'
    },
    'RO': <String, dynamic>{
      'name': 'Romania',
      'arabic_name': 'رومانيا',
      'capital': 'Bucharest',
      'timezone': 'Europe/Bucharest',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 44.4268,
      'longitude': 26.1025,
      'flag': '🇷🇴'
    },
    'RS': <String, dynamic>{
      'name': 'Serbia',
      'arabic_name': 'صربيا',
      'capital': 'Belgrade',
      'timezone': 'Europe/Belgrade',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 44.7866,
      'longitude': 20.4489,
      'flag': '🇷🇸'
    },

// PART 9
// RU -> ZW

    'RU': <String, dynamic>{
      'name': 'Russia',
      'arabic_name': 'روسيا',
      'capital': 'Moscow',
      'timezone': 'Europe/Moscow',
      // Russia spans 11 time zones, using Moscow's standard offset (UTC+3)
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 55.7558,
      'longitude': 37.6176,
      'flag': '🇷🇺'
    },
    'RW': <String, dynamic>{
      'name': 'Rwanda',
      'arabic_name': 'رواندا',
      'capital': 'Kigali',
      'timezone': 'Africa/Kigali',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -1.9499,
      'longitude': 30.0588,
      'flag': '🇷🇼'
    },
    'SA': <String, dynamic>{
      'name': 'Saudi Arabia',
      'arabic_name': 'المملكة العربية السعودية',
      'capital': 'Riyadh',
      'timezone': 'Asia/Riyadh',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 24.7136,
      'longitude': 46.6753,
      'flag': '🇸🇦'
    },
    'SB': <String, dynamic>{
      'name': 'Solomon Islands',
      'arabic_name': 'جزر سليمان',
      'capital': 'Honiara',
      'timezone': 'Pacific/Guadalcanal',
      'gmtOffset': 11,
      'rawOffset': 11,
      'latitude': -9.4280,
      'longitude': 159.9494,
      'flag': '🇸🇧'
    },
    'SC': <String, dynamic>{
      'name': 'Seychelles',
      'arabic_name': 'سيشيل',
      'capital': 'Victoria',
      'timezone': 'Indian/Mahe',
      'gmtOffset': 4,
      'rawOffset': 4,
      'latitude': -4.6191,
      'longitude': 55.4513,
      'flag': '🇸🇨'
    },
    'SD': <String, dynamic>{
      'name': 'Sudan',
      'arabic_name': 'السودان',
      'capital': 'Khartoum',
      'timezone': 'Africa/Khartoum',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 15.5007,
      'longitude': 32.5599,
      'flag': '🇸🇩'
    },
    'SE': <String, dynamic>{
      'name': 'Sweden',
      'arabic_name': 'السويد',
      'capital': 'Stockholm',
      'timezone': 'Europe/Stockholm',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 59.3293,
      'longitude': 18.0686,
      'flag': '🇸🇪'
    },
    'SG': <String, dynamic>{
      'name': 'Singapore',
      'arabic_name': 'سنغافورة',
      'capital': 'Singapore',
      'timezone': 'Asia/Singapore',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 1.3521,
      'longitude': 103.8198,
      'flag': '🇸🇬'
    },
    'SH': <String, dynamic>{
      'name': 'Saint Helena, Ascension and Tristan da Cunha',
      'arabic_name': 'سانت هيلينا وأسينشين وتريستان دا كونها',
      'capital': 'Jamestown (on Saint Helena)',
      'timezone': 'Atlantic/St_Helena',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': -15.9387,
      'longitude': -5.7167,
      'flag': '🇸🇭'
    },
    'SI': <String, dynamic>{
      'name': 'Slovenia',
      'arabic_name': 'سلوفينيا',
      'capital': 'Ljubljana',
      'timezone': 'Europe/Ljubljana',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 46.0569,
      'longitude': 14.5058,
      'flag': '🇸🇮'
    },
    'SJ': <String, dynamic>{
      'name': 'Svalbard and Jan Mayen',
      'arabic_name': 'سفالبارد ويان ماين',
      'capital': 'Longyearbyen',
      'timezone': 'Arctic/Longyearbyen',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 78.2232,
      'longitude': 15.6267,
      'flag': '🇸🇯'
    },
    'SK': <String, dynamic>{
      'name': 'Slovakia',
      'arabic_name': 'سلوفاكيا',
      'capital': 'Bratislava',
      'timezone': 'Europe/Bratislava',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 48.1486,
      'longitude': 17.1077,
      'flag': '🇸🇰'
    },
    'SL': <String, dynamic>{
      'name': 'Sierra Leone',
      'arabic_name': 'سيراليون',
      'capital': 'Freetown',
      'timezone': 'Africa/Freetown',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 8.4844,
      'longitude': -13.2344,
      'flag': '🇸🇱'
    },
    'SM': <String, dynamic>{
      'name': 'San Marino',
      'arabic_name': 'سان مارينو',
      'capital': 'City of San Marino',
      'timezone': 'Europe/San_Marino',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 43.9352,
      'longitude': 12.4474,
      'flag': '🇸🇲'
    },
    'SN': <String, dynamic>{
      'name': 'Senegal',
      'arabic_name': 'السنغال',
      'capital': 'Dakar',
      'timezone': 'Africa/Dakar',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 14.6928,
      'longitude': -17.4467,
      'flag': '🇸🇳'
    },
    'SO': <String, dynamic>{
      'name': 'Somalia',
      'arabic_name': 'الصومال',
      'capital': 'Mogadishu',
      'timezone': 'Africa/Mogadishu',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 2.0469,
      'longitude': 45.3182,
      'flag': '🇸🇴'
    },
    'SR': <String, dynamic>{
      'name': 'Suriname',
      'arabic_name': 'سورينام',
      'capital': 'Paramaribo',
      'timezone': 'America/Paramaribo',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': 5.8520,
      'longitude': -55.2038,
      'flag': '🇸🇷'
    },
    'SS': <String, dynamic>{
      'name': 'South Sudan',
      'arabic_name': 'جنوب السودان',
      'capital': 'Juba',
      'timezone': 'Africa/Juba',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 4.8517,
      'longitude': 31.5825,
      'flag': '🇸🇸'
    },
    'ST': <String, dynamic>{
      'name': 'Sao Tome and Principe',
      'arabic_name': 'ساو تومي وبرينسيبي',
      'capital': 'São Tomé',
      'timezone': 'Africa/Sao_Tome',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 0.3365,
      'longitude': 6.7273,
      'flag': '🇸🇹'
    },
    'SV': <String, dynamic>{
      'name': 'El Salvador',
      'arabic_name': 'السلفادور',
      'capital': 'San Salvador',
      'timezone': 'America/El_Salvador',
      'gmtOffset': -6,
      'rawOffset': -6,
      'latitude': 13.6929,
      'longitude': -89.2182,
      'flag': '🇸🇻'
    },
    'SX': <String, dynamic>{
      'name': 'Sint Maarten (Dutch part)',
      'arabic_name': 'سينت مارتن (الجزء الهولندي)',
      'capital': 'Philipsburg',
      'timezone': 'America/Lower_Princes',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.0260,
      'longitude': -63.0458,
      'flag': '🇸🇽'
    },
    'SY': <String, dynamic>{
      'name': 'Syria',
      'arabic_name': 'سوريا',
      'capital': 'Damascus',
      'timezone': 'Asia/Damascus',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 33.5138,
      'longitude': 36.2765,
      'flag': '🇸🇾'
    },
    'SZ': <String, dynamic>{
      'name': 'Eswatini',
      'arabic_name': 'إسواتيني',
      'capital': 'Mbabane (administrative), Lobamba (legislative)',
      'timezone': 'Africa/Mbabane',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -26.3054,
      'longitude': 31.1367,
      'flag': '🇸🇿'
    },
    'TC': <String, dynamic>{
      'name': 'Turks and Caicos Islands',
      'arabic_name': 'جزر توركس وكايكوس',
      'capital': 'Cockburn Town',
      'timezone': 'America/Grand_Turk',
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 21.4612,
      'longitude': -71.1419,
      'flag': '🇹🇨'
    },
    'TD': <String, dynamic>{
      'name': 'Chad',
      'arabic_name': 'تشاد',
      'capital': 'N’Djamena',
      'timezone': 'Africa/Ndjamena',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 12.1348,
      'longitude': 15.0557,
      'flag': '🇹🇩'
    },
    'TF': <String, dynamic>{
      'name': 'French Southern Territories',
      'arabic_name': 'الأقاليم الفرنسية الجنوبية',
      'capital': 'Port-aux-Français (Kerguelen Islands)',
      'timezone': 'Indian/Kerguelen',
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': -49.3500,
      'longitude': 70.2167,
      'flag': '🇹🇫'
    },
    'TG': <String, dynamic>{
      'name': 'Togo',
      'arabic_name': 'توغو',
      'capital': 'Lomé',
      'timezone': 'Africa/Lome',
      'gmtOffset': 0,
      'rawOffset': 0,
      'latitude': 6.1319,
      'longitude': 1.2220,
      'flag': '🇹🇬'
    },
    'TH': <String, dynamic>{
      'name': 'Thailand',
      'arabic_name': 'تايلاند',
      'capital': 'Bangkok',
      'timezone': 'Asia/Bangkok',
      'gmtOffset': 7,
      'rawOffset': 7,
      'latitude': 13.7563,
      'longitude': 100.5018,
      'flag': '🇹🇭'
    },
    'TJ': <String, dynamic>{
      'name': 'Tajikistan',
      'arabic_name': 'طاجيكستان',
      'capital': 'Dushanbe',
      'timezone': 'Asia/Dushanbe',
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': 38.5598,
      'longitude': 68.7870,
      'flag': '🇹🇯'
    },
    'TK': <String, dynamic>{
      'name': 'Tokelau',
      'arabic_name': 'توكيلو',
      'capital': 'Nukunonu (de facto)',
      'timezone': 'Pacific/Fakaofo',
      'gmtOffset': 13,
      'rawOffset': 13,
      'latitude': -9.2000,
      'longitude': -171.8333,
      'flag': '🇹🇰'
    },
    'TL': <String, dynamic>{
      'name': 'Timor-Leste',
      'arabic_name': 'تيمور الشرقية',
      'capital': 'Dili',
      'timezone': 'Asia/Dili',
      'gmtOffset': 9,
      'rawOffset': 9,
      'latitude': -8.5569,
      'longitude': 125.5736,
      'flag': '🇹🇱'
    },
    'TM': <String, dynamic>{
      'name': 'Turkmenistan',
      'arabic_name': 'تركمانستان',
      'capital': 'Ashgabat',
      'timezone': 'Asia/Ashgabat',
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': 37.9601,
      'longitude': 58.3261,
      'flag': '🇹🇲'
    },
    'TN': <String, dynamic>{
      'name': 'Tunisia',
      'arabic_name': 'تونس',
      'capital': 'Tunis',
      'timezone': 'Africa/Tunis',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 36.8065,
      'longitude': 10.1815,
      'flag': '🇹🇳'
    },
    'TO': <String, dynamic>{
      'name': 'Tonga',
      'arabic_name': 'تونغا',
      'capital': 'Nukuʻalofa',
      'timezone': 'Pacific/Tongatapu',
      'gmtOffset': 13,
      'rawOffset': 13,
      'latitude': -21.1394,
      'longitude': -175.2046,
      'flag': '🇹🇴'
    },
    'TR': <String, dynamic>{
      'name': 'Turkey',
      'arabic_name': 'تركيا',
      'capital': 'Ankara',
      'timezone': 'Europe/Istanbul',
      // Officially using UTC+3 year-round
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 39.9208,
      'longitude': 32.8541,
      'flag': '🇹🇷'
    },
    'TT': <String, dynamic>{
      'name': 'Trinidad and Tobago',
      'arabic_name': 'ترينيداد وتوباغو',
      'capital': 'Port of Spain',
      'timezone': 'America/Port_of_Spain',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 10.6600,
      'longitude': -61.4789,
      'flag': '🇹🇹'
    },
    'TV': <String, dynamic>{
      'name': 'Tuvalu',
      'arabic_name': 'توفالو',
      'capital': 'Funafuti',
      'timezone': 'Pacific/Funafuti',
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': -8.5201,
      'longitude': 179.1982,
      'flag': '🇹🇻'
    },
    'TW': <String, dynamic>{
      'name': 'Taiwan',
      'arabic_name': 'تايوان',
      'capital': 'Taipei',
      'timezone': 'Asia/Taipei',
      'gmtOffset': 8,
      'rawOffset': 8,
      'latitude': 25.0330,
      'longitude': 121.5654,
      'flag': '🇹🇼'
    },
    'TZ': <String, dynamic>{
      'name': 'Tanzania',
      'arabic_name': 'تنزانيا',
      'capital': 'Dodoma',
      // Largest city is Dar es Salaam, but capital is Dodoma
      'timezone': 'Africa/Dar_es_Salaam',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': -6.7924,
      'longitude': 39.2083,
      'flag': '🇹🇿'
    },
    'UA': <String, dynamic>{
      'name': 'Ukraine',
      'arabic_name': 'أوكرانيا',
      'capital': 'Kyiv',
      'timezone': 'Europe/Kiev',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': 50.4501,
      'longitude': 30.5234,
      'flag': '🇺🇦'
    },
    'UG': <String, dynamic>{
      'name': 'Uganda',
      'arabic_name': 'أوغندا',
      'capital': 'Kampala',
      'timezone': 'Africa/Kampala',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 0.3476,
      'longitude': 32.5825,
      'flag': '🇺🇬'
    },
    'UM': <String, dynamic>{
      'name': 'United States Minor Outlying Islands',
      'arabic_name': 'جزر الولايات المتحدة الصغيرة النائية',
      'capital': 'N/A (various atolls)',
      'timezone': 'Pacific/Midway',
      // depends on the specific island; e.g. Midway is UTC-11
      'gmtOffset': -11,
      'rawOffset': -11,
      'latitude': 28.2150,
      'longitude': -177.3720,
      'flag': '🇺🇸'
    },
    'US': <String, dynamic>{
      'name': 'United States',
      'arabic_name': 'الولايات المتحدة الأمريكية',
      'capital': 'Washington, D.C.',
      'timezone': 'America/New_York',
      // The US spans multiple time zones; using Washington, DC (UTC-5 standard)
      'gmtOffset': -5,
      'rawOffset': -5,
      'latitude': 38.9072,
      'longitude': -77.0369,
      'flag': '🇺🇸'
    },
    'UY': <String, dynamic>{
      'name': 'Uruguay',
      'arabic_name': 'أوروغواي',
      'capital': 'Montevideo',
      'timezone': 'America/Montevideo',
      'gmtOffset': -3,
      'rawOffset': -3,
      'latitude': -34.9011,
      'longitude': -56.1645,
      'flag': '🇺🇾'
    },
    'UZ': <String, dynamic>{
      'name': 'Uzbekistan',
      'arabic_name': 'أوزبكستان',
      'capital': 'Tashkent',
      'timezone': 'Asia/Tashkent',
      'gmtOffset': 5,
      'rawOffset': 5,
      'latitude': 41.2995,
      'longitude': 69.2401,
      'flag': '🇺🇿'
    },
    'VA': <String, dynamic>{
      'name': 'Vatican City',
      'arabic_name': 'دولة الفاتيكان',
      'capital': 'Vatican City',
      'timezone': 'Europe/Vatican',
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 41.9022,
      'longitude': 12.4539,
      'flag': '🇻🇦'
    },
    'VC': <String, dynamic>{
      'name': 'Saint Vincent and the Grenadines',
      'arabic_name': 'سانت فينسنت والغرينادين',
      'capital': 'Kingstown',
      'timezone': 'America/St_Vincent',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 13.1600,
      'longitude': -61.2248,
      'flag': '🇻🇨'
    },
    'VE': <String, dynamic>{
      'name': 'Venezuela',
      'arabic_name': 'فنزويلا',
      'capital': 'Caracas',
      'timezone': 'America/Caracas',
      // Historically UTC-4:30, changed to UTC-4 in 2016
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 10.4806,
      'longitude': -66.9036,
      'flag': '🇻🇪'
    },
    'VG': <String, dynamic>{
      'name': 'British Virgin Islands',
      'arabic_name': 'جزر فيرجن البريطانية',
      'capital': 'Road Town',
      'timezone': 'America/Tortola',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.4286,
      'longitude': -64.6185,
      'flag': '🇻🇬'
    },
    'VI': <String, dynamic>{
      'name': 'U.S. Virgin Islands',
      'arabic_name': 'جزر فيرجن الأمريكية',
      'capital': 'Charlotte Amalie',
      'timezone': 'America/St_Thomas',
      'gmtOffset': -4,
      'rawOffset': -4,
      'latitude': 18.3419,
      'longitude': -64.9307,
      'flag': '🇻🇮'
    },
    'VN': <String, dynamic>{
      'name': 'Vietnam',
      'arabic_name': 'فيتنام',
      'capital': 'Hanoi',
      'timezone': 'Asia/Ho_Chi_Minh',
      // Hanoi is also commonly "Asia/Bangkok" +7, but official is Asia/Ho_Chi_Minh
      'gmtOffset': 7,
      'rawOffset': 7,
      'latitude': 21.0278,
      'longitude': 105.8342,
      'flag': '🇻🇳'
    },
    'VU': <String, dynamic>{
      'name': 'Vanuatu',
      'arabic_name': 'فانواتو',
      'capital': 'Port Vila',
      'timezone': 'Pacific/Efate',
      'gmtOffset': 11,
      'rawOffset': 11,
      'latitude': -17.7333,
      'longitude': 168.3167,
      'flag': '🇻🇺'
    },
    'WF': <String, dynamic>{
      'name': 'Wallis and Futuna',
      'arabic_name': 'واليس وفوتونا',
      'capital': 'Mata-Utu',
      'timezone': 'Pacific/Wallis',
      'gmtOffset': 12,
      'rawOffset': 12,
      'latitude': -13.2816,
      'longitude': -176.1745,
      'flag': '🇼🇫'
    },
    'WS': <String, dynamic>{
      'name': 'Samoa',
      'arabic_name': 'ساموا',
      'capital': 'Apia',
      'timezone': 'Pacific/Apia',
      'gmtOffset': 13,
      'rawOffset': 13,
      'latitude': -13.8333,
      'longitude': -171.7667,
      'flag': '🇼🇸'
    },
    'XK': <String, dynamic>{
      'name': 'Kosovo',
      'arabic_name': 'كوسوفو',
      'capital': 'Pristina',
      'timezone': 'Europe/Belgrade',
      // Some systems use "Europe/Pristina" if available
      'gmtOffset': 1,
      'rawOffset': 1,
      'latitude': 42.6639,
      'longitude': 21.1622,
      'flag': '🇽🇰'
    },
    'YE': <String, dynamic>{
      'name': 'Yemen',
      'arabic_name': 'اليمن',
      'capital': "Sana'a",
      'timezone': 'Asia/Aden',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': 15.3694,
      'longitude': 44.1910,
      'flag': '🇾🇪'
    },
    'YT': <String, dynamic>{
      'name': 'Mayotte',
      'arabic_name': 'مايوت',
      'capital': 'Mamoudzou',
      'timezone': 'Indian/Mayotte',
      'gmtOffset': 3,
      'rawOffset': 3,
      'latitude': -12.7822,
      'longitude': 45.2279,
      'flag': '🇾🇹'
    },
    'ZA': <String, dynamic>{
      'name': 'South Africa',
      'arabic_name': 'جنوب أفريقيا',
      'capital': 'Pretoria (executive), Bloemfontein (judicial), Cape Town (legislative)',
      'timezone': 'Africa/Johannesburg',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -25.7479,
      'longitude': 28.2293,
      'flag': '🇿🇦'
    },
    'ZM': <String, dynamic>{
      'name': 'Zambia',
      'arabic_name': 'زامبيا',
      'capital': 'Lusaka',
      'timezone': 'Africa/Lusaka',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -15.3875,
      'longitude': 28.3228,
      'flag': '🇿🇲'
    },
    'ZW': <String, dynamic>{
      'name': 'Zimbabwe',
      'arabic_name': 'زيمبابوي',
      'capital': 'Harare',
      'timezone': 'Africa/Harare',
      'gmtOffset': 2,
      'rawOffset': 2,
      'latitude': -17.8252,
      'longitude': 31.0335,
      'flag': '🇿🇼'
    },


  };
}
