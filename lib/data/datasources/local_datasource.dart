import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {
  String getUserToken();
  Future<String> setUserToken(String userToken);
}

class LocalDatasourceImpl extends LocalDatasource {
  final SharedPreferences preferences;

  LocalDatasourceImpl(this.preferences);

  @override
  String getUserToken() {
    final result = preferences.getString('userToken');
    if (result == null || result.isEmpty) {
      return '';
    } else {
      return result;
    }
  }

  @override
  Future<String> setUserToken(String userToken) async {
    final result = await preferences.setString('userToken', userToken);
    if (result) {
      return userToken;
    } else {
      return userToken;
    }
  }
}
