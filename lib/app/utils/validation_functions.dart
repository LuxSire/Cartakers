/// Checks if string is email.
bool isValidEmail(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

/// check if token is valid or not
///
/// Token should have,

bool isTokenValid(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z0-9]{6,}$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

/// Password should have,
/// at least a upper case letter
///  at least a lower case letter
///  at least a digit
///  at least a special character [@#$%^&+=]
///  length of at least 4
/// no white space allowed
bool isValidPassword(String? inputString, {bool isRequired = false}) {
  // If the field is not required and the input is null or empty, consider it valid.
  if (!isRequired && (inputString == null || inputString.isEmpty)) {
    return true;
  }

  // Check if the input string is at least 5 characters long.
  if (inputString != null && inputString.length >= 5) {
    return true;
  }

  // If none of the conditions are met, the input is invalid.
  return false;
}

bool doPasswordsMatch(String password, String confirmPassword) {
  // Check if the two passwords are identical.
  return password == confirmPassword;
}
