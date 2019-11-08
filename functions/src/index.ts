// Created by George Nick Gorzynski © g30r93g 2019

const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);

const db = admin.firestore();
const messaging = admin.messaging();

exports.sendPushNotification = functions.firestore.document("Receipts/{receiptID}").onCreate( (snap, context) => {
  	console.log('Data: ', snap.data());

    const receiptID = context.params.receiptID;
  	const storeName = snap.data().store.storeName;
    const userID = snap.data().user;

  	console.log('Store Name:', storeName);
  	console.log('User ID: ', userID);
    console.log('Receipt ID: ', receiptID);

    const message = {
      notification: {
        title: 'New Receipt',
        body: 'You have a new receipt from ' + storeName,
        sound: 'default',
        badge: '1'
     },
     data: {
        "receiptID": receiptID
     }
    };

    var pushToken = "";
    return db.collection('Users').doc(userID).get().then(doc => {
     	pushToken = doc.data().tokenID;
     	console.log('User push token: ', pushToken)
     	return messaging.sendToDevice(pushToken, message)
     }).catch(error => {
     	console.log('Error getting push token for user ' + userID, error)
     })
});

exports.lookupUserID = admin.auth.getUser(uid).then(userRecord => {
  return true
}).catch(error => {
  return false
})
