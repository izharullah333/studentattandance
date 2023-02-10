import 'package:flutter/material.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    width: 300,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                        child: Text('View All Record',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
