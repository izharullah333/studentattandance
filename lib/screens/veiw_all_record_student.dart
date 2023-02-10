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
  DatabaseReference? RecordRef;

  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      RecordRef = databaseReference.child("attendance").child(user!.uid);
    }
    chekc();
    super.initState();
  }

  Future<List> chekc() async {
    List attandance = [];
    DatabaseEvent event = await FirebaseDatabase.instance
        .reference()
        .child("attendance")
        .child(user!.uid)
        .once();
    Object? value = event.snapshot.value;
    print(value);
    Map<dynamic, dynamic> map = value as Map;
    map.forEach((key, value) {
      Map valueMap = value;
      for (var key in valueMap.keys) {
        attandance.add(valueMap[key]);
      }
    });
    return attandance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('view Record'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 500,
            child: FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("attendance")
                    .child(user!.uid)
                    .once(),
                builder: (context, event) {
                  if (event.hasData) {
                    List attendanceValues = [];
                    List attendanceKeys = [];
                    List days = [];
                    Object? value = event.data?.snapshot.value;
                    print(value);
                    Map<dynamic, dynamic> map = value as Map;
                    map.forEach((key, value) {
                      Map valueMap = value;
                      days.add(key);
                      for (var key in valueMap.keys) {
                        attendanceValues.add(valueMap[key]);
                        attendanceKeys.add(key);
                      }
                    });
                    return ListView.builder(
                        itemCount: attendanceValues.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(attendanceValues[index]),
                              subtitle: Text(attendanceKeys[index]),
                              trailing: Text(days[index]),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
