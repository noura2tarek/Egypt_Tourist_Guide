import 'package:shared_preferences/shared_preferences.dart';
import '../app_images.dart';

class SharedPrefsService {
  static const String _userFullNameKey = 'user_full_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';
  static const String _userPhoneKey = 'user_phone';
  static const String _userProfilePicKey = 'user_profile_pic';
  static const String _userAddressKey = 'user_address';
  static String userProfilePicture = AppImages.user;
  static late SharedPreferences _sharedPreferences;

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /*-------------- Save user data -----------*/
  static Future<void> saveUserData({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
    String? profilePicUrl,
    String? address,
  }) async {
    await _sharedPreferences.setString(_userFullNameKey, fullName);
    await _sharedPreferences.setString(_userEmailKey, email);
    await _sharedPreferences.setString(_userPasswordKey, password);
    if (phoneNumber != null) {
      await _sharedPreferences.setString(_userPhoneKey, phoneNumber);
    }
    if (profilePicUrl != null) {
      await _sharedPreferences.setString(_userProfilePicKey, profilePicUrl);
    }
    if (address != null) {
      await _sharedPreferences.setString(_userAddressKey, address);
    }
  }

  /*-------------- Get user data from shared prefs ---------------*/
  static Future<Map<String, dynamic>> getUserData() async {
    return {
      'fullName': _sharedPreferences.getString(_userFullNameKey) ?? '',
      'email': _sharedPreferences.getString(_userEmailKey) ?? '',
      'password': _sharedPreferences.getString(_userPasswordKey) ?? '',
      'phoneNumber': _sharedPreferences.getString(_userPhoneKey),
      'profilePicUrl': _sharedPreferences.getString(_userProfilePicKey),
      'address': _sharedPreferences.getString(_userAddressKey),
    };
  }

  /*-------------- Clear user data ---------------*/
  static Future<void> clearUserData() async {
    await _sharedPreferences.remove(_userFullNameKey);
    await _sharedPreferences.remove(_userEmailKey);
    await _sharedPreferences.remove(_userPasswordKey);
    await _sharedPreferences.remove(_userPhoneKey);
    await _sharedPreferences.remove(_userProfilePicKey);
    await _sharedPreferences.remove(_userAddressKey);
  }

  /*-------------- Save string data ---------------*/
  static Future<bool> saveStringData(
      {required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
    return true;
  }

  /*------------ Get String data from shared prefs --------------*/
  static String? getStringData({required String key}) {
    String? value = _sharedPreferences.getString(key);
    return value;
  }

  static Future<bool> clearStringData({required String key}) async {
    await _sharedPreferences.remove(key);
    return true;
  }

  static String getProfilePhoto() {
    return _sharedPreferences.getString(userProfilePicture) ?? AppImages.user;
  }
}
