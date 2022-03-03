const {JWT} = require('google-auth-library');
const scope = ['https://www.googleapis.com/auth/firebase.messaging', 'https://www.googleapis.com/auth/drive']

function getAccessToken(){
    return new Promise(function(resolve, reject) {
      const key = require('./ia-bet-firebase-adminsdk-77wh8-66bb87b0b3.json');
      const jwtClient = new JWT(
        key.client_email,
        null,
        key.private_key,
        scope,
        null
      );
      jwtClient.authorize(function(err, tokens) {
        if (err) {
          reject(err);
          return;
        }
        resolve(tokens.access_token);
      });
    });
  }
getAccessToken().then(e => {
  console.log(e);
});
