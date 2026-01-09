class PetValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a name';
    final nameRegExp = RegExp(r"^[\p{L} '-]+$", unicode: true);
    if (!nameRegExp.hasMatch(value)) {
      return 'Please use only letters and common punctuation';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $fieldName';
    }
    return null;
  }
}
