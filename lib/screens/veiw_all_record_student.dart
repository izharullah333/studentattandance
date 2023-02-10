import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/all_button_student.dart';
class StudenRecord extends StatefulWidget {
  const StudenRecord({Key? key}) : super(key: key);

  @override
  State<StudenRecord> createState() => _StudenRecordState();
}

class _StudenRecordState extends State<StudenRecord> {
  DatabaseReference? RecordRef ;

  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      RecordRef =
                  databaseReference.child("attendance").child(user!.uid);
    }
    super.initState();
  }
  Future<void> chekc() async {
    List attandance = [];
    DatabaseEvent event =
    await FirebaseDatabase.instance.reference().child("attendance").child(user!.uid).once();
    Object? value = event.snapshot.value;
    Map<dynamic, dynamic> map = value as Map;
    map.forEach((key, value) {

      Map valueMap = value;
      for (var key in valueMap.keys) {

        attandance.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('view Record'),
      ),
      body: Column(
        children:  [
          Text('no'),
        ],
      ),
    );
  }
}
