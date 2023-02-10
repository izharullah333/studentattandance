import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studentattandance/screens/profile_screen.dart';
import 'package:studentattandance/screens/veiw_all_record_student.dart';
import 'package:studentattandance/widgets/all_button_student.dart';
class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Screen'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                  return ProfileScreen();
                }));
              }, icon: Icon(Icons.person))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Welcome to Eziline.com',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
              ],
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: (){
                setState(() {
                  markAttendance(user!.uid);
                });
              },
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: const Center(
                    child: Text('Present',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                ),
              ),
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: (){
                setState(() {
                  LeavAttendance(user!.uid);
                });
              },
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Center(
                    child: Text('Leave',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                ),
              ),
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                  return StudenRecord();
                }));
              },
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: const Center(
                    child: Text('View Record',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
