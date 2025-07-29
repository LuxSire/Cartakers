import 'package:bcrypt/bcrypt.dart';
import 'package:xm_frontend/data/api/translation_api.dart';

class Helpers {
  // Function to hash a password using bcrypt
  static String hashPassword(String plainPassword) {
    // Generate a salt and hash the password
    final hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    return hashedPassword;
  }

  // Function to verify a password with the hashed password
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    // Compare the plaintext password with the hashed password
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }

  static Future<String> translateText(String text) async {
    return await TranslationApi.smartTranslate(text);
  }

  // generate 4 digit random number
  static int generateRandomNumber() {
    return 1000 + (DateTime.now().millisecondsSinceEpoch % 9000);
  }
}
