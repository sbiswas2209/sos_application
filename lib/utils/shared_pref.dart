import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences = null;
  static Future<void> _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveContact(String phone) async {
    if (_sharedPreferences == null) {
      await _init();
    }
    List<String> savedContacts = await getAllSavedContacts();
    if (savedContacts.contains(phone)) {
      throw Exception("Contact already saved");
    }
    _sharedPreferences!.setStringList(
      "contacts",
      [...savedContacts, phone],
    );
  }

  static Future<List<String>> getAllSavedContacts() async {
    if (_sharedPreferences == null) {
      await _init();
    }
    return _sharedPreferences!.getStringList("contacts") ?? [];
  }

  static Future<void> removeSavedContact(String phone) async {
    if (_sharedPreferences == null) {
      await _init();
    }
    List<String> savedContacts = await getAllSavedContacts();
    savedContacts.removeWhere((element) => element == phone);
    _sharedPreferences!.setStringList("contacts", savedContacts);
  }
}
