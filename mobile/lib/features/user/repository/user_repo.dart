import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepo();
});

class UserRepo {
  final recommendationConfigureKeys = 'rec_configuration_key';

  Future<bool> saveRecConfiguration(dynamic body) async {
    print(body);
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(recommendationConfigureKeys, body);
  }

  Future<dynamic> getRecConfiguration() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(recommendationConfigureKeys);
  }
}
