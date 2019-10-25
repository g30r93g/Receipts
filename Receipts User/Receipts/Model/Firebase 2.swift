////
////  Firebase.swift
////  Receipts
////
////  Created by George Nick Gorzynski on 06/08/2018.
////  Copyright © 2018 g30r93g. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseAuth
//
//class Firebase {
//    
//    // MARK: Shared Instance
//    static let shared = Firebase()
//    
//    // MARK: Variables
//    let db = Firestore.firestore()
//    let auth = Auth.auth()
//    var receiptsQuery: Query!
//    var accountQuery: DocumentReference!
//    
//    var isSignedIn: Bool!
//    var user: User!
//    var userID: String!
//    var userEmail: String!
//    var lastSignIn: String!
//    var accountVerified: Bool!
//    var userFullName: String!
//	
//	// MARK: Enums
//	enum AuthError {
//		case networkTimeout
//		case noMatchingAccount
//		case wrongUsername
//		case wrongPassword
//		case usernameTaken
//		case passwordTooWeak
//		case passwordTooLong
//	}
//    
//    // MARK: Functions
//    /// Sets up firebase for use in the project
//    func setupFirebase(completion: @escaping() -> Void) {
//        // Enable offline data caching
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = true
//        
//        // Conform database to settings for offline data persistence
//        db.settings = settings
//        
//        // ONLY FOR DEBUG PURPOSES
////        self.signOut() {
////            print(" Debug: WARNING - Forcibly signed out!")
////        }
//        
//        self.determineSignInStatus()
//        
//        completion()
//    }
//    
//    /// Determines if the user is signed in and gets associated data with the account that is signed in
//    private func determineSignInStatus() {
//        // Determine if there is a user signed in
//        if let currentUser = auth.currentUser {
//            print(" Debug: User is signed in.")
//            
//            self.user = currentUser
//            self.userID = currentUser.uid
//            self.receiptsQuery = db.collection("Users").document(currentUser.uid).collection("Receipts").order(by: "date", descending: true)
//            self.userEmail = currentUser.email
//            self.lastSignIn = currentUser.metadata.lastSignInDate!.normaliseDate(format: "dd MMMM yyyy")
//            self.accountVerified = determineVerification()
//            self.accountQuery = db.collection("Users").document(currentUser.uid)
//            
//            self.accountQuery.getDocument { (snapshot, error) in
//                if let error = error {
//                    print(" Debug: Error - \(error.localizedDescription)")
//                } else if let data = snapshot!.data() {
//                    guard let name = data["name"] as? String else { fatalError("User Name unretrievable") }
//                    self.userFullName = name
//                }
//            }
//            
//            self.isSignedIn = true
//            print(" Debug: User data retrieved.")
//        } else {
//            print(" Debug: No user signed in.")
//            self.isSignedIn = false
//        }
//    }
//    
//    /// Sends a request to reload all account data
//    func reloadAccountData() {
//        user.reload { (error) in
//            if let error = error {
//                fatalError("Error reloading user data - \(error.localizedDescription)")
//            } else {
//                guard let email = self.user.email else { fatalError("Unable to Retrieve Email") }
//                guard let lastSignIn = self.user.metadata.lastSignInDate else { fatalError("Unable to Retrieve Last Sign In") }
//                
//                self.userEmail = email
//                self.lastSignIn = lastSignIn.normaliseDate(format: "dd MMMM yyyy")
//                self.accountVerified = self.user.isEmailVerified
//            }
//        }
//    }
//    
//    /// Determines if a user's email has been verified
//    func determineVerification() -> Bool {
//    }
//    
//    /// Gets barcode string
//    func userBarcode() -> String {
//        return Auth.auth().currentUser!.uid
//    }
//    
//    /// Sends a request to get receipts and also places a listener for new receipts.
//    func getReceipts(completion: @escaping() -> Void) {
//        receiptsQuery.addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print(" Debug: Error whilst getting receipts - \(error.localizedDescription)")
//            } else if let snapshot = snapshot {
//                snapshot.documentChanges.forEach({ (change) in
//                    if change.type == .added {
//                        print(" Debug: New receipt added")
//                        let receipt = change.document.data()
//                        
//                        var receiptProducts: [ReceiptContents] = []
//                        
//                        guard let storeName = receipt["storeName"] as? String else { fatalError() }
//                        guard let storeID = receipt["storeID"] as? String else { fatalError() }
//                        guard let date = receipt["date"] as? Date else { fatalError() }
//                        guard let receiptContents = receipt["receiptContents"] as? [[String : Any]] else { fatalError() }
//                        guard let total = receipt["total"] as? Double else { fatalError() }
//                        guard let currencyPrefix = receipt["currencyPrefix"] as? String else { fatalError() }
//                        guard let taxPercent = receipt["taxPercent"] as? Double else { fatalError() }
//                        guard let payedByCard = receipt["payedByCard"] as? Bool else { fatalError() }
//                        guard let returnsPolicy = receipt["returnsPolicy"] as? String else { fatalError() }
//                        guard let location = receipt["location"] as? GeoPoint else { fatalError() }
//                        
//                        for product in receiptContents {
//                            guard let name = product["name"] as? String else { fatalError() }
//                            guard let price = product["price"] as? Double else { fatalError() }
//                            guard let quantity = product["quantity"] as? Int else { fatalError() }
//                            guard let returned = product["returned"] as? Bool else { fatalError() }
//                            
//                            receiptProducts.append(ReceiptContents(itemName: name, itemCost: price, itemQuantity: quantity, itemReturned: returned))
//                        }
//                        
//                        if (payedByCard) {
//                            guard let cardNumberEnding = receipt["cardNumberEnding"] as? Int else { fatalError() }
//                            guard let cardType = receipt["cardType"] as? String else { fatalError() }
//                            
//                            receipts.append(Receipt(storeName: storeName, storeID: storeID, date: date, location: location, receiptContents: receiptProducts, taxPercent: taxPercent, total: total, currencyPrefix: currencyPrefix, payedByCard: payedByCard, cardNumberEnding: cardNumberEnding, cardType: cardType, returnsPolicy: returnsPolicy))
//                        } else {
//                            receipts.append(Receipt(storeName: storeName, storeID: storeID, date: date, location: location, receiptContents: receiptProducts, taxPercent: taxPercent, total: total, currencyPrefix: currencyPrefix, payedByCard: payedByCard, cardNumberEnding: nil, cardType: nil, returnsPolicy: returnsPolicy))
//                        }
//                        
//                        completion()
//                    }
//                })
//            }
//        }
//    }
//    
//}
