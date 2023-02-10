import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:studentattandance/screens/admin_screen.dart';
import 'package:studentattandance/screens/signup_screen.dart';
import 'package:studentattandance/screens/student_attandance_screen.dart';
class StudentSinginScreen extends StatefulWidget {
  const StudentSinginScreen({Key? key}) : super(key: key);

  @override
  State<StudentSinginScreen> createState() => _StudentSinginScreenState();
}

class _StudentSinginScreenState extends State<StudentSinginScreen> {
  @override
  Widget build(BuildContext context) {
    bool passobsecure = true;
    final EmailController = TextEditingController();
    final PassController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signing Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
        child: Column(
          children:  [
            TextField(
              controller: EmailController,
              decoration:  InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon (Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: PassController,
              obscureText: passobsecure,
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
                    passobsecure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      passobsecure = !passobsecure;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                fillColor: Colors.white,
                filled: true,
              ),
            ),

            const SizedBox(height: 20),
            GestureDetector( //we use container for signing button
              onTap: () async {
                var email = EmailController.text;
                var password = PassController.text;
                var formValid = true;

                if(email.isEmpty){
                  Fluttertoast.showToast(msg: 'please Enter Email');
                  formValid = false;
                }
                 if(password.isEmpty){
                  Fluttertoast.showToast(msg: 'please Enter Password');
                  formValid = false;
                }
                 if(email == 'admin@gmail.com' && password == 'admin1234'){
                   Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                     return AdminScreen();
                   }));
                   formValid = false;
                 }
                if(formValid == false){
                  return ;
                }
                ProgressDialog progressdialog = ProgressDialog(
                    context,
                    title: const Text('Singing'),
                    message: const Text('please wait')
                );
                progressdialog.show();
                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                try{
                  UserCredential usercredential = await firebaseAuth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  progressdialog.dismiss();

                  User? user = usercredential.user;
                  if(user != null){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                      return const StudentScreen();
                    }));
                  }
                }
                on FirebaseAuthException catch (e){
                  progressdialog.dismiss();
                  if(e.code == 'user-not-found'){
                    Fluttertoast.showToast(msg: 'user not found');
                  }else if(e.code =='wrong-password' ){
                    Fluttertoast.showToast(msg: 'wrong password');
                  }
                }
              },
              child: Container(
                height: 50,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue
                ),
                child: const Text('SingIn',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white
                  ),),
              ),
            ),
            const SizedBox(height: 10),
            // ElevatedButton(
            //     onPressed: (){
            //       if(adminEmail=='admin@gmail.com' && password == '123456'){
            //         Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            //           return const AdminScreen();
            //         }));
            //       }
            //       return ;
            //       //Fluttertoast.showToast(msg: 'pleas enter correct account');
            //     },
            //     child: const Text('login is admin')),

            Expanded(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                    return const StudentSignUpScreen();
                  }));
                },
                child: Container(
                  height: 80,
                  alignment: Alignment.center,// text alignment
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue
                  ),
                  child: const Text('do not have account sign up',style: TextStyle(
                      fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white
                  ),),
                ),
              ),
            )
            )
          ],
        ),
      ),
    );
  }
}
