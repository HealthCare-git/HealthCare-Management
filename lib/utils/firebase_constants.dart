import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp(
  options: const FirebaseOptions(
      apiKey: "AIzaSyBnw2EAWDht1CtQTFR5ZfDpuYaUqPIegT0",
      authDomain: "healthcare-2c808.firebaseapp.com",
      projectId: "healthcare-2c808",
      storageBucket: "healthcare-2c808.appspot.com",
      messagingSenderId: "5028793711",
      appId: "1:5028793711:web:d9d3d8ad474a4aa981ec9a",
      measurementId: "G-GP7VTMLY09"
  ),
);
//var user = AuthController.authInstance.firebaseUser.value;
//var uuid=Uuid().v1();
//String perId = "HCID${user?.uid}";