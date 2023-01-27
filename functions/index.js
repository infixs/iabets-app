const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const runtimeOpts = {
  timeoutSeconds: 30,
  memory: '1GB'
}

exports.sendMessage = functions.runWith(runtimeOpts).region('southamerica-east1').https.onCall(async (data, context) => {
  admin
    .messaging()
    .send({
      topic: "chat",
      data: {
        channelId: data.channelId
      },
      notification: {
        title: data.channelName,
        body: data.message,
        //imageUrl: "https://my-cdn.com/extreme-weather.png",
      },
      android: {
        priority: "high",
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
        headers: {
          "apns-priority": "10"
        },
      },
    })
    .then((response) => {
      console.log("Successfully sent message:", response);
    })
    .catch((error) => {
      console.log("Error sending message:", error);
    });
})

exports.crashUpdate = functions.region('southamerica-east1').firestore
  .document('configurations/blazeCrashEntry')
  .onUpdate((change, context) => {

    const newValue = change.after.data().waiting;
    const previousValue = change.before.data().waiting;

    if (!(previousValue && !newValue))
      return null;

    admin
      .messaging()
      .send({
        topic: "crash",
        data: {
          crash: "true"
        },
        notification: {
          title: "Nova entrada crash",
          body: "Veja aqui a nova entrada do Blaze Crash",
          //imageUrl: "https://my-cdn.com/extreme-weather.png",
        },
        android: {
          priority: "high",
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
          headers: {
            "apns-priority": "10"
          },
        },
      })
      .then((response) => {
        console.log("Successfully sent message:", response);
      })
      .catch((error) => {
        console.log("Error sending message:", error);
      });
  });


  exports.aviatorUpdate = functions.region('southamerica-east1').firestore
  .document('configurations/playpixAviatorEntry')
  .onUpdate((change, context) => {

    const newValue = change.after.data().waiting;
    const previousValue = change.before.data().waiting;

    if (!(previousValue && !newValue))
      return null;

    admin
      .messaging()
      .send({
        topic: "aviator",
        data: {
          crash: "true"
        },
        notification: {
          title: "Nova entrada Aviator",
          body: "Veja aqui a nova entrada do Aviator",
          //imageUrl: "https://my-cdn.com/extreme-weather.png",
        },
        android: {
          priority: "high",
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
          headers: {
            "apns-priority": "10"
          },
        },
      })
      .then((response) => {
        console.log("Successfully sent message:", response);
      })
      .catch((error) => {
        console.log("Error sending message:", error);
      });
  });