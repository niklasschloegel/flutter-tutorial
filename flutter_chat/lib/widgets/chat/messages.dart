import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'message_bubble.dart';

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
                  final doc = docs[index];
                  return MessageBubble(
                    key: ValueKey(doc.id),
                    text: doc["text"],
                    userName: doc["username"],
                    isMe: doc["userId"] ==
                        (FirebaseAuth.instance.currentUser?.uid ?? false),
                    dateString: DateFormat("dd.MM.yyyy - HH:mm").format(
                        (doc["createdAt"] as Timestamp).toDate().toLocal()),
                  );
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
