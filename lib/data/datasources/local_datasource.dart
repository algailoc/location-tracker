import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {
  String getJwt();
}

class LocalDatasourceImpl extends LocalDatasource {
  final SharedPreferences preferences;

  LocalDatasourceImpl(this.preferences);

  @override
  String getJwt() {
    final result = preferences.getString('jwt');
    if (result == null || result.isEmpty) {
      return 'sQbVfRGbqA2kwBLlh7eU';
    } else {
      return 'sQbVfRGbqA2kwBLlh7eU';
    }
  }
}
