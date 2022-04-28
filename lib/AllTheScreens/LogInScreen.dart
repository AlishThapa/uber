import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllTheScreens/MainScreen.dart';
import 'package:rider_app/AllTheScreens/RegistrationScreen.dart';
import 'package:rider_app/main.dart';

const textStyle = TextStyle(
  fontSize: 25.0,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
);

class LogInScreen extends StatelessWidget {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Image(
                image: AssetImage(
                  'images/logo.png',
                ),
                height: 300.0,
                width: 300.0,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60.0,
                  fontFamily: 'Signatra',
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Center(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextEditingController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: textStyle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        //obscure text means that whatever is written will not be shown,
                        //instead of that '*' will be shown.
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: textStyle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          Fluttertoast.showToast(msg: "Invalid Email");
                        } else if (passwordTextEditingController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Password Required!!");
                        } else {
                          LoginUser(context);
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    textButton(
                      title: 'Don\'t have an account? register here!',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void LoginUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError(
      (errMsg) {
        Fluttertoast.showToast(
          msg: "Error: " + toString(),
        );
      },
    ))
        .user;
    if (firebaseUser != null) {
      usersRef
          .child(firebaseUser.uid)
          .once()
          .then((value) => (DataSnapshot snap) {
                if (snap.value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                  Fluttertoast.showToast(msg: "Logged In!");
                } else {
                  _firebaseAuth.signOut();
                  Fluttertoast.showToast(
                      msg:
                          "Such account doesn\'t exist. Please make a new account.!");
                }
              });
    } else {
      Fluttertoast.showToast(msg: "Couldn\'t sign in");
    }
  }
}

class textButton extends StatelessWidget {
  const textButton({required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 19.0, color: Colors.white),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
