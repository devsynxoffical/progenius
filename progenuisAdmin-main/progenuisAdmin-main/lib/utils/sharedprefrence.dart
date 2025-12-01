import 'package:shared_preferences/shared_preferences.dart';

class Sharedprefrence {
  static const String _accessTokenKey = 'accessToken';

  // Save access token
  static Future<void> saveAccessToken(String accessToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
    } catch (e) {
      print("Error saving token: $e");
    }
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      print("Error getting token: $e");
      return null;
    }
  }

  // Check if token exists (Not expired, just checking presence)
  static Future<bool> isTokenAvailable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_accessTokenKey);
    } catch (e) {
      print("Error checking token: $e");
      return false;
    }
  }

  // Clear access token (Logout)
  static Future<void> clearAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
    } catch (e) {
      print("Error clearing token: $e");
    }
  }
}
