import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo/alluser.dart';

class messages extends StatefulWidget {
  final String recivername;
  final String username;
  messages({Key? key, required this.recivername, required this.username})
      : super(key: key);

  @override
  State<messages> createState() => _messagesState();
}

class _messagesState extends State<messages> {
  TextEditingController message = TextEditingController();
  DatabaseReference? senderref;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    senderref =
        FirebaseDatabase.instance.ref().child("users").child(widget.username);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<dynamic> sortMessages(List<dynamic> messages) {
    messages.sort((a, b) => a['messageno'].compareTo(b['messageno']));
    return messages;
  }

  Future<int> maxmessage() async {
    int highest = 0;
    final getmanmessage =
        FirebaseDatabase.instance.ref().child("users").child(widget.username);
    await getmanmessage.onValue.first.then((event) {
      var snapshot = event.snapshot;
      dynamic value = snapshot.value;
      if (value != true && value != null) {
        value.forEach((key, value) {
          if (value['messageno'] > highest) {
            highest = value['messageno'];
          }
        });
      }
    });
    return highest + 1;
  }

  void sendmessage() async {
    int getmaxvalue = await maxmessage();
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('HH:mm').format(now);
    String messages = message.text;

    final dbRefreciever = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(widget.recivername)
        .push();
    dbRefreciever.set({
      "sendername": widget.username,
      "recievername": widget.recivername,
      "message": messages,
      "time": formattedDateTime,
      "messageno": getmaxvalue,
    });

    final dbRefsender = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(widget.username)
        .push();
    dbRefsender.set({
      "sendername": widget.username,
      "recievername": widget.recivername,
      "message": messages,
      "time": formattedDateTime,
      "messageno": getmaxvalue,
    });
    message.clear();

    // Check if the scroll controller has clients and the list view is attached
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
      // Scroll to the bottom with animation
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 253, 239),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 90, // Fixed height for the sender and receiver names
            color: Colors.white,
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: Container(
                width: 56,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              allusershow(username: widget.username)),
                    );
                  },
                  iconSize: 20,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  widget.recivername,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null ||
                    snapshot.data!.snapshot.value == true) {
                  return const Center(
                    child: Text(
                      "No messages available",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  list = sortMessages(list);
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Reverse the order of items
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = list.length - 1 - index;
                      if (list[reversedIndex]["recievername"] ==
                              widget.recivername &&
                          list[reversedIndex]["sendername"] ==
                              widget.username) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(
                                      255, 135, 206, 250), // Light sky blue
                                  Color.fromARGB(255, 209, 229, 255), // Dark sky blue
                                ],
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 100, top: 10, right: 20),
                            child: ListTile(
                              title: Text(list[reversedIndex]["message"]),
                              subtitle: Container(
                                alignment: Alignment
                                    .bottomRight, // Aligns the subtitle to the bottom right
                                child: Text(
                                  list[reversedIndex]["time"],
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (list[reversedIndex]["sendername"] ==
                              widget.recivername &&
                          list[reversedIndex]["recievername"] ==
                              widget.username) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 255, 232, 239), // Light pink
                                  Color.fromARGB(255, 255, 191, 228), // Dark pink
                                ],
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 20, top: 10, right: 100),
                            child: ListTile(
                              title: Text(list[reversedIndex]["message"]),
                              subtitle: Container(
                                alignment: Alignment
                                    .bottomRight, // Aligns the subtitle to the bottom right
                                child: Text(list[reversedIndex]["time"],style: TextStyle(fontSize: 10),),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }
              },
              stream: senderref!.onValue,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: message,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Message",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendmessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
