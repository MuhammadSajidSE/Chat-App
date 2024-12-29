// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo/message.dart';

class allusershow extends StatefulWidget {
  final String username;
  allusershow({Key? key, required this.username}) : super(key: key);

  @override
  State<allusershow> createState() => _allusershowState();
}

class _allusershowState extends State<allusershow> {
  List<dynamic> alluser = [];

  @override
  void initState() {
    super.initState();
    getuser();
  }

  void getuser() {
    final dbRef = FirebaseDatabase.instance.ref().child("users");
    dbRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? data =
          dataSnapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          alluser = data.keys.toList();
          alluser.remove(widget.username);
        });
      }
    }, onError: (error) {
      print("Error fetching student data: $error");
      // Handle error as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 248, 255),
      body: Center(
        child: Column(
          children: [
            design(),
            Text(
              "${widget.username}'s contact list",
              style: const TextStyle(fontSize: 28),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alluser.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 187, 255), // Change color to sky blue
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4), // Padding for inner border
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust to your preference
                        border: const Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 197, 197, 197),
                              width: 7),
                          right: BorderSide(
                           color: Color.fromARGB(255, 197, 197, 197),
                              width: 5),
                        ),
                      ),
                      child: InkWell(
                        child: ListTile(
                          leading: const Icon(Icons.person_3,color: Color.fromARGB(255, 176, 176, 176),),
                          title: Text(
                            alluser[index],
                            style: const TextStyle(fontSize: 25,color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => messages(
                                  username: widget.username,
                                  recivername: alluser[index]),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget greenBox({required Color color}) {
  return Container(
    height: 250,
    width: 250,
    decoration: BoxDecoration(
      color: color,
      // borderRadius: BorderRadius.circular(250),
    ),
  );
}

Widget design() {
  return SizedBox(
    width: double.infinity,
    height: 135,
    child: Stack(
      children: [
        Positioned(
          top: -140,
          left: -140,
          child: greenBox(color: const Color.fromARGB(255, 156, 206, 247)),
        ),
        Positioned(
          top: -190,
          left: 60,
          right: 220,
          child: greenBox(color: const Color.fromARGB(255, 212, 156, 247)),
        ),
        Positioned(
          top: 80,
          left: -200,
          bottom: -90,
          child: greenBox(color: const Color.fromARGB(255, 162, 156, 247)),
        ),
      ],
    ),
  );
}
