import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {
  String getJwt();
  Future<String> setJwt(String jwt);
}

class LocalDatasourceImpl extends LocalDatasource {
  final SharedPreferences preferences;

  LocalDatasourceImpl(this.preferences);

  @override
  String getJwt() {
    final result = preferences.getString('jwt');
    if (result == null || result.isEmpty) {
      return '';
    } else {
      return 'sQbVfRGbqA2kwBLlh7eU';
    }
  }

  @override
  Future<String> setJwt(String jwt) async {
    final result = await preferences.setString('jwt', jwt);
    if (result) {
      return 'sQbVfRGbqA2kwBLlh7eU';
    } else {
      return 'sQbVfRGbqA2kwBLlh7eU';
    }
  }
}
