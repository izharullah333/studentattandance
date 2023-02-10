import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

  final databaseReference = FirebaseDatabase.instance.reference();
  User? user = FirebaseAuth.instance.currentUser;

  void markAttendance(String userId) async {
    DateTime now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";

    // Check if the user has already marked attendance for today
    var attendanceRef = databaseReference.child("attendance").child(user!.uid).child(date);
    var snapshot = await attendanceRef.once();
    if (snapshot.snapshot.value != null && attendanceRef.key!.isNotEmpty) {
      Fluttertoast.showToast(msg: 'already mark present');
      return;
    }
    // If the user hasn't marked attendance, mark it now
    attendanceRef.set({"marked": 'Present'}
    );
  }

void LeavAttendance(String userId) async {
  DateTime now = DateTime.now();
  String date = "${now.year}-${now.month}-${now.day}";

  // Check if the user has already marked attendance for today
  var attendanceRef = databaseReference.child("attendance").child(user!.uid).child(date);
  var snapshot = await attendanceRef.once();
  if (snapshot.snapshot.value != null && attendanceRef.key!.isNotEmpty) {
    Fluttertoast.showToast(msg: 'already leave marked ');
    return;
  }
  // If the user hasn't marked attendance, mark it now
  attendanceRef.set({"marked": 'leave'}
  );
}

