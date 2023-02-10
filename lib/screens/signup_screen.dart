import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:studentattandance/screens/student_singin_screen.dart';

class StudentSignUpScreen extends StatefulWidget {
  const StudentSignUpScreen({Key? key}) : super(key: key);

  @override
  _StudentSignUpScreenState createState() => _StudentSignUpScreenState();
}

class _StudentSignUpScreenState extends State<StudentSignUpScreen> {
  bool passwordObscured = true;
  bool confirmPassObscured = true;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: 'FullName',
                  prefixIcon: const Icon(
                    Icons.account_box,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: passwordObscured,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordObscured = !passwordObscured;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: retypePasswordController,
                obscureText: confirmPassObscured,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: 'Retype Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmPassObscured = !confirmPassObscured;
                      });
                    },
                    icon: Icon(confirmPassObscured
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(    // we use a container for button so we use GestureDetector an it have ontap
                onTap: () async {
                  var formValid = true; //all textfailed will be true mean fill....
                  var fullName = fullNameController.text;
                  var email = emailController.text;
                  var password = passwordController.text;
                  var retypePassword = retypePasswordController.text;

                  if (fullName.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide FullName');
                    formValid = false;
                  }

                  if (email.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide email');
                    formValid = false;
                  }

                  if (password.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide Password');
                    formValid = false;
                  }

                  if (retypePassword.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please provide Retype Password');
                    formValid = false;
                  }

                  if (password.length < 6) {
                    Fluttertoast.showToast(
                        msg: 'Please provide at least 6 digits');
                    formValid = false;
                  }

                  if (password != retypePassword) {
                    Fluttertoast.showToast(msg: 'Passwords do not match');
                    formValid = false;
                  }

                  if (formValid == false) {
                    return;
                  }
                  // show progress dialog when user sign up indialoge
                  ProgressDialog progressDialog = ProgressDialog(
                      context,
                      message: const Text("Signing Up"),
                      title: const Text("Please wait...")// show dialog initial
                  );
                  progressDialog.show();
                  // firebase auth initialization make object
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                  try { // user sign in with email and pass
                    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    progressDialog.dismiss();
                    User? user = userCredential.user;//store user data
                    if (user != null){
                      // save record in realtime database and also set reference child etc
                      final databaseReference = FirebaseDatabase.instance.reference();
                      await databaseReference.child('users').child(user.uid).set(
                          {
                            'uid': user.uid,
                            'name': fullName,
                            'email': email,
                            'dt': DateTime.now().millisecondsSinceEpoch,
                            'profileImage': '',
                            'password': password,
                          }
                      );

                      Fluttertoast.showToast(msg: 'Sign Up Successful');
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return StudentSinginScreen();
                      }));
                      progressDialog.dismiss();
                    }
                  } on FirebaseAuthException catch (e) {     // this msg come from firebase
                    progressDialog.dismiss();
                    if (e.code == 'weak-password') {
                      Fluttertoast.showToast(msg: 'Weak Password');
                    } else if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(msg: 'Email Already in Use');
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Something went wrong');
                    progressDialog.dismiss();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  margin: const EdgeInsets.symmetric(horizontal: 50.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
