import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  final _collectionPath = "chats/r9VCPxfQTQiPR8eIvDgl/messages";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(_collectionPath)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            final docs = snapshot.data?.docs;
            return docs == null
                ? Center(child: Text("Something went wrong :("))
                : ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final doc = docs[i];
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: Text(doc["text"]),
                      );
                    },
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection(_collectionPath)
              .add({"text": "This was added by clicking the button"});
        },
      ),
    );
  }
}
