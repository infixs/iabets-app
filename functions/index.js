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
                headers: { '1q'
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