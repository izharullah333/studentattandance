import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import '../model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  bool showLocalImage = false;
  UserModel? userModel;
  User? user;// from auth
  DatabaseReference? userRef; //database ref...

  _getUserDetails() async {
    if (userRef != null) {
      userRef!.once().then((dataSnapshot) {  // give data to snapshot and give to model
        userModel = UserModel.fromJson(Map<String, dynamic>.from(dataSnapshot.snapshot.value as Map));
        setState(() { //run app again
        });
      });
    }
  }
  _pickImageGellary() async{
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery); //source path of gallery
    if(xFile == null) return;
    final tempImage = File(xFile.path); // storing image path in variable
    image = tempImage; //storing image in file
    showLocalImage = true; // show image
    setState(() {

    });
    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('uploading !!!'),
      message: const Text('please wait....')
    );

    progressDialog.show();

    //upload fire storage...

    var fieName = DateTime.now().microsecondsSinceEpoch.toString() +'.jpg';// image type
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(fieName).putFile(image!); //store image in storage
    TaskSnapshot snapshot  = await uploadTask;  //when image upload...
    String imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);

    //update image

    if(userRef != null){
      userRef!.update(
        {
          'profileImage' : imageUrl,
        }
      );
    }
    progressDialog.dismiss();

  }
  _pickImageCamera() async {
      XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if(xFile == null) return;

  }

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // ignore: deprecated_member_use
      userRef = FirebaseDatabase.instance.reference().child('users').child(user!.uid);
    }
    _getUserDetails(); //show user details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: userModel == null ? const Center(child: CircularProgressIndicator()) :
            Column(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Stack(
                    children: [
                      ClipOval(
                        child: showLocalImage == true ? Image.file(
                          image! ,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        )
                            :Image.network(
                            userModel?.profileImage == ''? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                                : userModel!.profileImage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        )
                      ),
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            _pickImageGellary();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            _pickImageCamera();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Member Since: ${getHumanReadableDate(userModel!.dt)}'),
                          Row(
                            children: [
                              Expanded(
                                child: Text('FullName ${userModel!.name}'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                          Text('Email: ${userModel!.email}'),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            )
    ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd-MMM-yyy').format(dateTime);
  }
}