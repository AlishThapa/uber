import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'AllTheScreens/LogInScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}
DatabaseReference usersRef= FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlueAccent,
          title: 'Ride Sharing App',
        home: LogInScreen(),

    );
  }
}
