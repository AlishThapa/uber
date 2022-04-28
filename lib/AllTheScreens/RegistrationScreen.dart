import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllTheScreens/MainScreen.dart';
import 'package:rider_app/main.dart';
import 'LogInScreen.dart';

class RegistrationScreen extends StatelessWidget {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  RegistrationScreen({Key? key}) : super(key: key);
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
              const SizedBox(height: 40),
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
                'Register',
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
                    TextFielD(
                      name: TextInputType.text,
                      labeltext: 'Name',
                      textEditingController: nameTextEditingController,
                    ),
                    TextFielD(
                      name: TextInputType.emailAddress,
                      labeltext: 'Email',
                      textEditingController: emailTextEditingController,
                    ),
                    TextFielD(
                      name: TextInputType.phone,
                      labeltext: 'Phone Number',
                      textEditingController: phoneTextEditingController,
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 5) {
                          Fluttertoast.showToast(
                              msg: "Name should be atleast 5 characters");
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          Fluttertoast.showToast(msg: "Invalid Email");
                        } else if (phoneTextEditingController.text.isEmpty ||
                            phoneTextEditingController.text.length < 10) {
                          Fluttertoast.showToast(
                              msg:
                                  "Number field should be filled or Invalid Number");
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          Fluttertoast.showToast(
                              msg: "Password must be atleast 6 characters");
                        } else {
                          RegisterNewUser(context);
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    textButton(
                      title: 'Already have an account?',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
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
  void RegisterNewUser(BuildContext context) async {
    final User? user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
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
    if (user != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      usersRef.child(user.uid).set(userDataMap);
      Fluttertoast.showToast(msg: "Congrats");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "User has not been created");
    }
  }
}

class TextFielD extends StatelessWidget {
  const TextFielD(
      {required this.name,
      required this.labeltext,
      required this.textEditingController});
  final TextInputType name;
  final String labeltext;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: textEditingController,
        keyboardType: name,
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: textStyle,
        ),
      ),
    );
  }
}
