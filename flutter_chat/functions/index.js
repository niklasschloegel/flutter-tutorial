const functions = require("firebase-functions")
const admin = require("firebase-admin")

admin.initializeApp()

exports.notificationOnChatMessage = functions.firestore
    .document("chat/{message}")
    .onCreate((snapshot, _) => {
      const data = snapshot.data()
      return admin.messaging().send({
        topic: "chat",
        notification: {
          title: data.username,
          body: data.text,
          imageUrl: data.userImage,
        },
      })
    })
