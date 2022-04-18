import 'package:firebase_core/firebase_core.dart';

class LocalFirebase {
  static Future<FirebaseApp> init() async {
    FirebaseApp app = await Firebase.initializeApp();

    return app;
  }
}
