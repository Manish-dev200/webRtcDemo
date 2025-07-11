

import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage{
  final SharedPreferencesAsync db = SharedPreferencesAsync();

  Future<void> setUserId(String value) async {
    return await db.setString("userId", value);
  }

  Future<String> getUserId() async {
    return await db.getString("userId")??'';
  }

  Future<void> clearDb() async {
   return await db.clear();
  }

}