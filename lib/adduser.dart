// ignore_for_file: sort_child_properties_last

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo/alluser.dart';
import 'package:todo/loginuser.dart';

class adduser extends StatefulWidget {
  const adduser({super.key});
  @override
  State<adduser> createState() => _adduserState();
}

class _adduserState extends State<adduser> {
  TextEditingController name = new TextEditingController();
  void stdregister() {
    final dbRef = FirebaseDatabase.instance.ref().child("users");
    String username = name.text;
    dbRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? data =
          dataSnapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        if (data.containsKey(username)) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   // const SnackBar(
          //   //   backgroundColor: Colors.blue,
          //   //   content: Text("This account exist please enter differnet name"),
          //   // ),
          // )
        } else {
          dbRef.child(username).set(true).then((value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => allusershow(username: username)),
                )
              });
        }
      }
    }, onError: (error) {
      print("Error fetching student data: $error");
      // Handle error as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              design(),
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Register User",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all()
                  // Remove the Border.all() to remove the default border
                ),
                child: TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    hintText: "Enter your name",
                    border: InputBorder.none, // Remove the default border
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all()),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    border: InputBorder.none, 
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 250,
                height: 40, // Set the width as per your requirement
                child: ElevatedButton(
                  onPressed: stdregister,
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 147, 186, 232), // Change the background color here
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: const Text(
                  "If have an accout login now?",
                  style: TextStyle(color: Colors.purple),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const userlogin(),
                    ),
                  );
                },
              )
            ],
          ),
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
