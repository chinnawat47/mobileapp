import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/register_data.dart';

class RegistrationStorage {
  static const String _key = 'registrations';

  static Future<List<RegisterData>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getStringList(_key) ?? <String>[];
    return rawItems
        .map((json) => RegisterData.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> save(List<RegisterData> registrations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = registrations
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList(_key, encoded);
  }
}
