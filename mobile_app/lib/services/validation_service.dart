class ValidationService {
  // Validate username (only letters and numbers allowed)
  static String? validateUsername(String value) {
    final RegExp usernameRegex = RegExp(r'^[A-Za-z0-9]+$');
    if (value.isEmpty) {
      return "Username is required!";
    } else if (!usernameRegex.hasMatch(value)) {
      return "Username can only contain letters and numbers!";
    }
    return null;
  }

  // Validate email format
  static String? validateEmail(String value) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value.isEmpty) {
      return "Email is required!";
    } else if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address!";
    }
    return null;
  }

  // Validate password (Must contain at least one number)
  static String? validatePassword(String value) {
    final RegExp passwordRegex = RegExp(r'^(?=.*\d).{6,}$');
    if (value.isEmpty) {
      return "Password is required!";
    } else if (!passwordRegex.hasMatch(value)) {
      return "Password must be at least 6 characters long and contain a number!";
    }
    return null;
  }
}
