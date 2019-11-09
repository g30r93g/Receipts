//
//  Receipts.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 21/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Receipts {
	
	// MARK: Shared Instance
	static let current = Receipts()
	
	// MARK: Firestore Data Variables
	var receipts: [Receipt] = [] {
		didSet {
			self.receipts.sort(by: {$0.date.dateValue() < $1.date.dateValue()} )
		}
	}
	
	// MARK: Firestore Data Structs
	struct Receipt {
		var seen: Bool
		
		let date: Timestamp
		let identifier: String
		let storeDetails: StoreDetails
		let transactionDetails: ReceiptDetails
	}
	
	struct StoreDetails {
		let uid: String
		let name: String
		let location: GeoPoint
	}
	
	struct ReceiptDetails {
		let items: [Item]
		
		let subtotal: Double
		let discount: Double?
		let total: Double
		
		let paymentMethods: [PaymentMethod]
	}
	
	struct Item {
		let uid: String
		let name: String
		let price: Double
		let quantity: Int
	}
	
	struct PaymentMethod {
		let type: Method
		
		let amount: Double
		
		let cardNumber: Int?
		let cardVendor: Vendor?
		
		let creditRemaining: Double?
	}
	
	// MARK: Enum
	enum Method: String {
		case card = "card"
		case cash = "cash"
		case storeCredit = "storeCredit"
	}
	
	enum Vendor: String {
		case visa = "visa"
		case mastercard = "mastercard"
		case amex = "amex"
		case paypal = "paypal"
		case maestro = "maestro"
		case cirrus = "cirrus"
		case dinersClub = "dinersClub"
		case jcb = "jcb"
		case discover = "discover"
		case unionPay = "unionPay"
	}
	
	// MARK: Firestore Variables
	var data = Firestore.firestore()
	
	// MARK: Firestore Structs
	struct DocReferences {
		let reference: DocumentReference
		let isSeen: Bool
	}
	
	// MARK: Firestore Methods
	/// Retrieves all receipt references
	private func getReceiptRefs(completion: @escaping([DocReferences]) -> Void) {
		print("Getting Receipt References...")
		
		let userReference: DocumentReference = data.collection("Users").document(Authentication.account.uniqueIdentifier)
		
		// Get Receipt Document References
		var receipts: [DocReferences] = []
		userReference.getDocument { (document, error) in
			if let error = error {
				print("\(error)")
				completion([])
			} else if let data = document?.data() {
				
				let receiptReferences = data["receipts"] as! [DocumentReference]
				let unreadReceiptReferences = data["unreadReceipts"] as! [DocumentReference]
			
				receiptReferences.forEach( { receipts.append(DocReferences(reference: $0, isSeen: !unreadReceiptReferences.contains($0))) } )
				
				completion(receipts)
			} else {
				completion([])
			}
		}
	}
	
	/// Gets all receipts - parses all data
	private func getReceiptDetails(references: [DocReferences], completion: @escaping([Receipt]) -> Void) {
		print("Getting Receipt Details... - \(references)")
		let receiptReference: CollectionReference = data.collection("Receipts")
		self.receipts.removeAll()
		
		for reference in references {
			receiptReference.document(reference.reference.documentID).getDocument { (matchingDocument, error) in
				if let error = error {
					print("\(error)")
					completion([])
				} else if let matchingDocument = matchingDocument {
					print("Collating Receipt Details...")
					// Generate receipt for user to view
					let data = matchingDocument.data()!
					
					let seen: Bool = reference.isSeen
					let date: Timestamp = data["date"] as! Timestamp
					
					var storeDetails: StoreDetails {
						let store = data["store"] as! [String : Any]
						
						let uid: String = store["uuid"] as! String
						let name: String = store["name"] as! String
						let location: GeoPoint = store["location"] as! GeoPoint
						
						return StoreDetails(uid: uid, name: name, location: location)
					}
					
					var transactionDetails: ReceiptDetails {
						let details = data["transaction"] as! [String : Any]
						let items = details["items"] as! [[String : Any]]
						let paymentMethods = details["paymentMethods"] as! [[String : Any]]
						
						let subtotal: Double = details["subtotal"] as! Double
						let total: Double = details["total"] as! Double
						let discountAmount: Double = details["discount"] as! Double
						
						var decodedItems: [Item] = []
						for item in items {
							let uid: String = item["uuid"] as! String
							let name: String = item["name"] as! String
							let price: Double = item["price"] as! Double
							let quantity: Int = item["quantity"] as! Int
							
							decodedItems.append(Item(uid: uid, name: name, price: price, quantity: quantity))
						}
						
						var decodedPaymentMethods: [PaymentMethod] = []
						for paymentMethod in paymentMethods {
							let type: Method = Method(rawValue: paymentMethod["type"] as! String)!
							let amount: Double = paymentMethod["amount"] as! Double
							
							let cardNumber: Int? = paymentMethod["cardNumber"] as? Int
							let parsedCardVendor: String? = paymentMethod["cardVendor"] as? String
							var cardVendor: Vendor? {
								if parsedCardVendor == nil {
									return nil
								} else {
									return Vendor(rawValue: parsedCardVendor!)
								}
							}
							let creditRemaining: Double? = paymentMethod["creditRemaining"] as? Double
							
							decodedPaymentMethods.append(PaymentMethod(type: type, amount: amount, cardNumber: cardNumber, cardVendor: cardVendor, creditRemaining: creditRemaining))
						}
						
						return ReceiptDetails(items: decodedItems, subtotal: subtotal, discount: discountAmount, total: total, paymentMethods: decodedPaymentMethods)
					}
					
					self.receipts.append(Receipt(seen: seen, date: date, identifier: reference.reference.documentID, storeDetails: storeDetails, transactionDetails: transactionDetails))
					
					print("New Receipt Parsed! - \(self.receipts)")
					
					if self.receipts.count == references.count {
						completion(self.receipts)
						return
					}
				} else {
					completion([])
				}
			}
		}
	}
	
	func retrieveReceipts(endDate: Timestamp, completion: @escaping([Receipt]) -> Void) {
		self.getReceiptRefs { (references) in
			self.getReceiptDetails(references: references) { (receipts) in
				completion(receipts)
			}
		}
	}
	
}
