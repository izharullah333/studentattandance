import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studentattandance/screens/student_singin_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentSinginScreen(),

    );
  }
}

