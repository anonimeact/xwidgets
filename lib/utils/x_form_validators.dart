/// Validator class that provides various common validation types with customizable error messages
class XFormValidator {
  /// Default error messages in English
  static const Map<String, String> _defaultMessages = {
    'required': 'This field is required',
    'maxLength': 'Maximum {maxLength} characters allowed',
    'minLength': 'Minimum {minLength} characters required',
    'email': 'Invalid email format',
    'phoneNumber': 'Invalid phone number format',
    'nik': 'NIK must be 16 digits',
    'nisn': 'NISN must be 10 digits',
    'bankAccount': 'Invalid bank account number',
    'birthDate': 'Invalid date format',
    'nip': 'NIP must be 18 digits',
    'password': 'Password does not meet requirements',
    'idCard': 'Invalid identification number',
    'numeric': 'Only numbers are allowed',
    'alphabetic': 'Only letters are allowed',
    'alphanumeric': 'Only letters and numbers are allowed',
    'url': 'Invalid URL format',
    'postalCode': 'Postal code must be 5 digits',
    'ktp': 'KTP must be 16 digits',
    'sim': 'Invalid SIM number',
  };

  /// Validates if the field is empty
  static String? Function(String?) required({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? _defaultMessages['required'];
      }
      return null;
    };
  }

  /// Validates maximum length
  static String? Function(String?) maxLength(int maxLength, {String? message}) {
    return (String? value) {
      if (value != null && value.length > maxLength) {
        return message ??
            _defaultMessages['maxLength']!.replaceAll(
              '{maxLength}',
              maxLength.toString(),
            );
      }
      return null;
    };
  }

  /// Validates minimum length
  static String? Function(String?) minLength(int minLength, {String? message}) {
    return (String? value) {
      if (value != null && value.length < minLength) {
        return message ??
            _defaultMessages['minLength']!.replaceAll(
              '{minLength}',
              minLength.toString(),
            );
      }
      return null;
    };
  }

  /// Validates email format
  static String? Function(String?) email({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegex.hasMatch(value)) {
        return message ?? _defaultMessages['email'];
      }
      return null;
    };
  }

  /// Validates phone number format
  static String? Function(String?) phoneNumber({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      // Remove spaces and punctuation
      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // Validate Indonesian phone number format (e.g., 081234567890)
      final phoneRegex = RegExp(r'^(\+62|0)[0-9]{10,13}$');

      if (!phoneRegex.hasMatch(cleaned)) {
        return message ?? _defaultMessages['phoneNumber'];
      }
      return null;
    };
  }

  /// Validates NIK (Indonesian ID Number)
  static String? Function(String?) nik({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // NIK must be 16 digits
      if (cleaned.length != 16) {
        return message ?? _defaultMessages['nik'];
      }

      // Validate NIK format (16 digits)
      if (!RegExp(r'^[0-9]{16}$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['nik'];
      }

      return null;
    };
  }

  /// Validates NISN (National Student ID Number)
  static String? Function(String?) nisn({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // NISN must be 10 digits
      if (cleaned.length != 10) {
        return message ?? _defaultMessages['nisn'];
      }

      // Validate NISN format (10 digits)
      if (!RegExp(r'^[0-9]{10}$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['nisn'];
      }

      return null;
    };
  }

  /// Validates bank account number
  static String? Function(String?) bankAccount({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // Bank account numbers are usually 10-20 digits
      if (cleaned.length < 10 || cleaned.length > 20) {
        return message ?? _defaultMessages['bankAccount'];
      }

      // Validate only numbers
      if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['bankAccount'];
      }

      return null;
    };
  }

  /// Validates birth date (format DD/MM/YYYY or YYYY-MM-DD)
  static String? Function(String?) birthDate({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      try {
        // Try to parse the date
        final date = DateTime.parse(value);

        // Validate not in the future
        if (date.isAfter(DateTime.now())) {
          return message ?? _defaultMessages['birthDate'];
        }

        // Validate minimum age (e.g., 1 year)
        if (date.isAfter(DateTime.now().subtract(const Duration(days: 365)))) {
          return message ?? _defaultMessages['birthDate'];
        }

        return null;
      } catch (e) {
        return message ?? _defaultMessages['birthDate'];
      }
    };
  }

  /// Validates employee ID (NIP)
  static String? Function(String?) nip({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // NIP is usually 18 digits
      if (cleaned.length != 18) {
        return message ?? _defaultMessages['nip'];
      }

      // Validate NIP format (18 digits)
      if (!RegExp(r'^[0-9]{18}$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['nip'];
      }

      return null;
    };
  }

  /// Validates password strength
  static String? Function(String?) password({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      // Validate minimum length of 8 characters
      if (value.length < 8) {
        return message ?? _defaultMessages['password'];
      }

      // Validate has uppercase letter
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return message ?? _defaultMessages['password'];
      }

      // Validate has lowercase letter
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return message ?? _defaultMessages['password'];
      }

      // Validate has number
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return message ?? _defaultMessages['password'];
      }

      // Validate has special character
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return message ?? _defaultMessages['password'];
      }

      return null;
    };
  }

  /// Validates identification number (general)
  static String? Function(String?) idCard({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // Validate only numbers
      if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['idCard'];
      }

      return null;
    };
  }

  /// Combines multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  /// Validates only numbers
  static String? Function(String?) numeric({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return message ?? _defaultMessages['numeric'];
      }

      return null;
    };
  }

  /// Validates only letters
  static String? Function(String?) alphabetic({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        return message ?? _defaultMessages['alphabetic'];
      }

      return null;
    };
  }

  /// Validates alphanumeric characters
  static String? Function(String?) alphanumeric({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
        return message ?? _defaultMessages['alphanumeric'];
      }

      return null;
    };
  }

  /// Validates URL format
  static String? Function(String?) url({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final urlRegex = RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      );

      if (!urlRegex.hasMatch(value)) {
        return message ?? _defaultMessages['url'];
      }

      return null;
    };
  }

  /// Validates postal code
  static String? Function(String?) postalCode({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // Postal code is usually 5 digits
      if (cleaned.length != 5) {
        return message ?? _defaultMessages['postalCode'];
      }

      // Validate only numbers
      if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['postalCode'];
      }

      return null;
    };
  }

  /// Validates KTP (Indonesian ID Card)
  static String? Function(String?) ktp({String? message}) {
    return nik(message: message);
  }

  /// Validates SIM card number
  static String? Function(String?) sim({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

      // SIM numbers are usually 12-13 digits
      if (cleaned.length < 12 || cleaned.length > 13) {
        return message ?? _defaultMessages['sim'];
      }

      // Validate only numbers
      if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
        return message ?? _defaultMessages['sim'];
      }

      return null;
    };
  }

  /// Sets default messages for a specific language
  static void setDefaultMessages(Map<String, String> messages) {
    // This can be used to set messages in other languages
    // Example: setDefaultMessages({'required': 'This field is required', ...})
  }
}
