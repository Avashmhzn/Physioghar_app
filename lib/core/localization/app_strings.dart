enum AppLanguage { english, nepali }

class AppStrings {
  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    'app_name': {
      AppLanguage.english: 'PhysioGhar',
      AppLanguage.nepali: 'फिजियोगर',
    },
    'therapist_portal': {
      AppLanguage.english: 'Therapist Portal',
      AppLanguage.nepali: 'थेरापिस्ट पोर्टल',
    },
    'available': {
      AppLanguage.english: 'Available',
      AppLanguage.nepali: 'उपलब्ध',
    },
    'unavailable': {
      AppLanguage.english: 'Unavailable',
      AppLanguage.nepali: 'अनुपलब्ध',
    },
    'today_schedule': {
      AppLanguage.english: "Today's Schedule",
      AppLanguage.nepali: 'आजको तालिका',
    },
    'upcoming_sessions': {
      AppLanguage.english: 'Upcoming Sessions',
      AppLanguage.nepali: 'आगामी सत्रहरू',
    },
    'todays_sessions': {
      AppLanguage.english: "Today's Sessions",
      AppLanguage.nepali: 'आजका सत्रहरू',
    },
    'upcoming_requests': {
      AppLanguage.english: 'Upcoming Requests',
      AppLanguage.nepali: 'नयाँ अनुरोधहरू',
    },
    'completed_sessions': {
      AppLanguage.english: 'Completed Sessions',
      AppLanguage.nepali: 'सम्पन्न सत्रहरू',
    },
    'schedule': {
      AppLanguage.english: 'Schedule',
      AppLanguage.nepali: 'तालिका',
    },
    'sessions': {
      AppLanguage.english: 'Sessions',
      AppLanguage.nepali: 'सत्रहरू',
    },
    'patients': {
      AppLanguage.english: 'Patients',
      AppLanguage.nepali: 'बिरामीहरू',
    },
    'profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.nepali: 'प्रोफाइल',
    },
    'requests': {
      AppLanguage.english: 'Requests',
      AppLanguage.nepali: 'अनुरोधहरू',
    },
    'upcoming': {
      AppLanguage.english: 'Upcoming',
      AppLanguage.nepali: 'आगामी',
    },
    'completed': {
      AppLanguage.english: 'Completed',
      AppLanguage.nepali: 'सम्पन्न',
    },
    'cancelled': {
      AppLanguage.english: 'Cancelled',
      AppLanguage.nepali: 'रद्द गरिएको',
    },
    'accept': {
      AppLanguage.english: 'Accept',
      AppLanguage.nepali: 'स्वीकार गर्नुहोस्',
    },
    'decline': {
      AppLanguage.english: 'Decline',
      AppLanguage.nepali: 'अस्वीकार गर्नुहोस्',
    },
    'mark_completed': {
      AppLanguage.english: 'Mark Completed',
      AppLanguage.nepali: 'सम्पन्न चिन्ह लगाउनुहोस्',
    },
    'reschedule': {
      AppLanguage.english: 'Reschedule',
      AppLanguage.nepali: 'पुनः तालिका बनाउनुहोस्',
    },
    'add_note': {
      AppLanguage.english: 'Add Note',
      AppLanguage.nepali: 'टिप्पणी थप्नुहोस्',
    },
    'edit_profile': {
      AppLanguage.english: 'Edit Profile',
      AppLanguage.nepali: 'प्रोफाइल सम्पादन',
    },
    'complaints': {
      AppLanguage.english: 'Report an Issue',
      AppLanguage.nepali: 'गुनासो / समस्या दर्ता',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.nepali: 'भाषा',
    },
    'open': {
      AppLanguage.english: 'OPEN',
      AppLanguage.nepali: 'खुला',
    },
    'booked': {
      AppLanguage.english: 'BOOKED',
      AppLanguage.nepali: 'बुक गरिएको',
    },
    'blocked': {
      AppLanguage.english: 'BLOCKED',
      AppLanguage.nepali: 'बन्द',
    },
    'save_changes': {
      AppLanguage.english: 'Save Changes',
      AppLanguage.nepali: 'परिवर्तनहरू बचत गर्नुहोस्',
    },
  };

  static String get(String key, AppLanguage lang) {
    return _localizedValues[key]?[lang] ?? key;
  }
}
