import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final docs = snapshot.data?.docs;
        final length = docs?.length ?? 0;

        return (docs != null && length > 0)
            ? ListView.builder(
                itemCount: length,
                reverse: true,
                itemBuilder: (ctx, index) {
                  final msg = docs[index]["text"];
                  return msg != null ? Text(msg) : Text("ERROR");
                },
              )
            : Center(
                child: Text("No messages written yet.",
                    style: TextStyle(
                      color: Colors.grey.shade300,
                    )),
              );
      },
    );
  }
}
