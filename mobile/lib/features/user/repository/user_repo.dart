import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepo();
});

class UserRepo {
  final recommendationConfigureKeys = 'rec_configuration_key';

  Future<bool> saveRecConfiguration(dynamic body) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(recommendationConfigureKeys, body);
  }

  Future<String?> getRecConfiguration() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(recommendationConfigureKeys);
  }

  Future<dynamic> removeRecConfiguration() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(recommendationConfigureKeys);
  }
}
