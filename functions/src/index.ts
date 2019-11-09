// Created by George Nick Gorzynski © g30r93g 2019

// MARK: Imports
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const express = require('express');

// MARK: Initialisation
admin.initializeApp();

// MARK: Constants
const db = admin.firestore();
const messaging = admin.messaging();
const app = express();
// const gmailEmail = functions.config().gmail.email;
// const gmailPassword = functions.config().gmail.password;
// const mailTransport = nodemailer.createTransport({
//   service: 'gmail',
//   auth: {
//     user: gmailEmail,
//     pass: gmailPassword,
//   },
// });

// Check if user exists
app.get('/checkUserID/:userID', async (request: any, response: any) => {
    const userID: String = request.params.userID;
  
    console.log(`Looking up user ${userID}`);
  
    try {
        db.doc("Users/"+userID).get().then((documentSnapshot: any) => {
            const userExists: Boolean = documentSnapshot.exists;

            console.log(`${userID} exists = ${userExists}`)

            if (userExists) {
                response.set('Cache-Control', 'private, max-age=300');
                return response.sendStatus(200);
            } else {
                return response.sendStatus(404).json({errorCode: 400, errorMessage: `User '${userID}' not found`});
            }
        });
    } catch(error) {
        console.log('Error checking if user exists:', userID, error.message);
        return response.sendStatus(404);
    }
});

exports.api = functions.https.onRequest(app);

// Add receipt reference to user and store collection
exports.addReferences = functions.firestore.document("Receipts/{receiptID}").onCreate(async (snap: any, context: any) => {
    const receiptID: String = context.params.receiptID;
    const userID: String = snap.data().user;
    const storeID: String = snap.data().store.uuid;
    const receiptReference = db.doc("Receipt/"+receiptID);

    console.log("Receipt ID: " + receiptID);
    console.log("User ID: " + userID);
    console.log("Store ID: " + storeID);
    console.log("Receipt Ref: " + receiptReference);

    try {
        // Set User
        db.doc("Users/"+userID).update({
            receipts: admin.firestore.FieldValue.arrayUnion(receiptReference),
            unreadReceipts: admin.firestore.FieldValue.arrayUnion(receiptReference)
        }, { merge: true });

        // Set Store
        db.doc("Stores/"+storeID).update({
            receipts: admin.firestore.FieldValue.arrayUnion(receiptReference),
            unreadReceipts: admin.firestore.FieldValue.arrayUnion(receiptReference)
        }, { merge: true });

        return;
    } catch(error) {
        console.log('Error adding receipt reference to user:', userID, error.message);
        return;
    }
});

// Send Push Notification for New Receipt
exports.sendPushNotification = functions.firestore.document("Receipts/{receiptID}").onCreate( (snap: any, context: any) => {
    const receiptID: String = context.params.receiptID;
  	const storeName: String = snap.data().store.storeName;
    const userID: String = snap.data().user;

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

    return db.collection('Users').doc(userID).get().then( (doc: any) => {
        const pushToken = doc.data().tokenID;
        console.log(`Sending notification for new receipt to ${userID}`)
        return messaging.sendToDevice(pushToken, message)
     }).catch( (error: any) => {
        console.log('Error getting push token for user ' + userID, error)
     })
});

// // Send Email Notification for New Receipt
// exports.sendEmailNotification = functions.firestore.document("Receipts/{receiptID}").onCreate( (snap, context) => {
//     const mailOptions = {
//         from: '"Receipts." <noreply-receipts@gmail.com>',
//         to: val.email,
//     };

//     const subscribed = val.subscribedToMailingList;
//     // Building Email message.
//     mailOptions.subject = subscribed ? 'Thanks and Welcome!' : 'Sad to see you go :`(';
//     mailOptions.text = subscribed ?
//     'Thanks you for subscribing to our newsletter. You will receive our next weekly newsletter.' :
//     'I hereby confirm that I will stop sending you the newsletter.';
//     try {
//     await mailTransport.sendMail(mailOptions);
//     console.log(`New ${subscribed ? '' : 'un'}subscription confirmation email sent to:`, val.email);
//         } catch(error) {
//     console.error('There was an error while sending the email:', error);
//         }
//     return null;
// });
