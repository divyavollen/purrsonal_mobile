class InputValidator {
  static final _nameRegExp = RegExp(r"^[\p{L} '-]+$", unicode: true);

  static String? validateRequiredInput(String? value, String fieldName) {
    final requiredError = validateRequired(value, fieldName);
    if (requiredError != null) return requiredError;

    return validateInput(value);
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a $fieldName';
    }
    return null;
  }

  static String? validateInput(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!_nameRegExp.hasMatch(value)) {
      return 'Please use only letters and common punctuation';
    }

    return null;
  }
}
