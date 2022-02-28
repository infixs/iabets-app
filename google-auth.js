import { GoogleAuth } from 'google-auth-library';

function getAccessToken() {
    return new Promise(function(resolve, reject) {
      const key = require('./ia-bet-firebase-adminsdk-77wh8-66bb87b0b3.json');
      const jwtClient = new GoogleAuth.JWT(
        key.client_email,
        null,
        key.private_key,
        SCOPES,
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
getAccessToken();