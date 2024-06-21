import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  SharedPreference._privateConstructor();
  static final SharedPreference instance = SharedPreference._privateConstructor();
  static late SharedPreferences _preferences;
  Future init() async => _preferences = await SharedPreferences.getInstance();

  String? getData(String key) => _preferences.getString(key);
  setData({required String key, String? value}) {
    //debugPrint('key is $key, value is $value');
    _preferences.setString(key, value ?? '');
  }
  clear() => _preferences.clear();
}
