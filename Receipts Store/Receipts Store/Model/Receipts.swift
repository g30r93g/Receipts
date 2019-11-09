//
//  Receipts.swift
//  Receipts Store
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
			NotificationCenter.default.post(name: Notification.Name("ReceiptsChanged"), object: nil)
			self.receipts.sort(by: {$0.date.dateValue() < $1.date.dateValue()} )
		}
	}
	var store: StoreDetails {
		return StoreDetails(uuid: Authentication.account.uniqueIdentifier, name: Authentication.account.storeDetails.name, location: GeoPoint(latitude: 51.612250, longitude: -0.169036))
	}
	
	// MARK: Firestore Data Structs
	struct Receipt {
		var seen: Bool
		
		let date: Timestamp
		let identifier: String
		let storeDetails: StoreDetails
		let transactionDetails: ReceiptDetails
		let userID: String
	}
	
	struct StoreDetails {
		let uuid: String
		let name: String
		let location: GeoPoint
		
		func toAnyObject() -> Any {
			return [
				"uuid" : uuid,
				"name" : name,
				"location" : location
			]
		}
	}
	
	struct ReceiptDetails {
		let items: [Item]
		
		let subtotal: Double
		let discount: Double
		let total: Double
		
		let paymentMethods: [PaymentMethod]
		
		func toAnyObject() -> Any {
			return [
				"items" : items.map({$0.toAnyObject()}),
				"subtotal" : subtotal,
				"discount" : discount,
				"total" : total,
				"paymentMethods" : paymentMethods.map({$0.toAnyObject()})
			]
		}
	}
	
	struct Item {
		let uuid: String
		let name: String
		let price: Double
		let quantity: Int
		
		func toAnyObject() -> Any {
			return [
				"uuid" : uuid,
				"name" : name,
				"price" : price,
				"quantity" : quantity
			]
		}
	}
	
	struct PaymentMethod {
		let type: Method
		
		let amount: Double
		
		let cardNumber: Int
		let cardVendor: Vendor
		
		let creditRemaining: Double
		
		func toAnyObject() -> Any {
			return [
				"type" : type.rawValue,
				"amount" : amount,
				"cardNumber" : cardNumber,
				"cardVendor" : cardVendor.rawValue,
				"creditRemaining" : creditRemaining
			]
		}
	}
	
	// MARK: Enum
	enum Method: String {
		case card = "card"
		case cash = "cash"
		case storeCredit = "storeCredit"
		
		func toAnyObject() -> Any {
			return self.rawValue
		}
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
		
		func toAnyObject() -> Any {
			return self.rawValue
		}
	}
	
	// MARK: Firestore Variables
	var data = Firestore.firestore()
	
	// MARK: Firestore Structs
	struct DocReferences {
		let reference: DocumentReference
		let isSeen: Bool
	}
	
	// MARK: Firestore Methods
	func retrieveReceipts(completion: @escaping([Receipt]) -> Void) {
		print("Getting Receipt References...")
		self.getReceiptRefs { (references) in
			self.getReceiptDetails(references: references) { (receipts) in
				completion(receipts)
			}
		}
	}
	
	private func getReceiptRefs(completion: @escaping([DocReferences]) -> Void) {
		let storeReference: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier)
		
		// Get Receipt Document References
		var receipts: [DocReferences] = []
		storeReference.getDocument { (document, error) in
			if let error = error {
				print("\(error)")
				completion([])
				return
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
	
	private func getReceiptDetails(references: [DocReferences], completion: @escaping([Receipt]) -> Void) {
		// Get Each Receipt
		print("Getting Receipt Details...")
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
					let user: String = data["user"] as! String
					
					var storeDetails: StoreDetails {
						let store = data["store"] as! [String : Any]
						
						let uuid: String = store["uuid"] as! String
						let name: String = store["name"] as! String
						let location: GeoPoint = store["location"] as! GeoPoint
						
						return StoreDetails(uuid: uuid, name: name, location: location)
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
							let uuid: String = item["uuid"] as! String
							let name: String = item["name"] as! String
							let price: Double = item["price"] as! Double
							let quantity: Int = item["quantity"] as! Int
							
							decodedItems.append(Item(uuid: uuid, name: name, price: price, quantity: quantity))
						}
						
						var decodedPaymentMethods: [PaymentMethod] = []
						for paymentMethod in paymentMethods {
							let type: Method = Method(rawValue: paymentMethod["type"] as! String)!
							let amount: Double = paymentMethod["amount"] as! Double
							
							let cardNumber: Int = paymentMethod["cardNumber"] as! Int
							let cardVendor: Vendor = Vendor(rawValue: paymentMethod["cardVendor"] as! String)!
							let creditRemaining: Double = paymentMethod["creditRemaining"] as! Double
							
							decodedPaymentMethods.append(PaymentMethod(type: type, amount: amount, cardNumber: cardNumber, cardVendor: cardVendor, creditRemaining: creditRemaining))
						}
						
						return ReceiptDetails(items: decodedItems, subtotal: subtotal, discount: discountAmount, total: total, paymentMethods: decodedPaymentMethods)
					}
					
					self.receipts.append(Receipt(seen: seen, date: date, identifier: reference.reference.documentID, storeDetails: storeDetails, transactionDetails: transactionDetails, userID: user))
					
					print("New Receipt Parsed! - \(self.receipts)")
					
					if self.receipts.count == references.count {
						completion(self.receipts)
					}
				} else {
					completion([])
				}
			}
		}
		
		completion([])
	}
	
	func uploadSalesReceipt(sale: Sale, completion: @escaping(Receipt?) -> Void) {
		let newReceiptDocument: DocumentReference = data.collection("Receipts").document()
		
		let transactionDetails: ReceiptDetails = ReceiptDetails(items: sale.items.map({Item(uuid: $0.uuid, name: $0.name, price: $0.price, quantity: $0.quantity)}), subtotal: sale.total, discount: 0, total: sale.total, paymentMethods: sale.payment)
		
		let receipt: Receipts.Receipt = Receipts.Receipt(seen: false, date: Date().convertToTimestamp(), identifier: newReceiptDocument.documentID, storeDetails: self.store, transactionDetails: transactionDetails, userID: sale.userCode)
		print("Receipt ID: \(receipt.identifier)")
		print("User ID: \(receipt.userID)")
		
		newReceiptDocument.setData([
			"date" : receipt.date,
			"user" : receipt.userID,
			"store" : receipt.storeDetails.toAnyObject(),
			"transaction" : receipt.transactionDetails.toAnyObject(),
		]) { (error) in
			if let error = error {
				print("Error: \(error)")
				completion(nil)
			} else {
				completion(receipt)
			}
		}
	}
	
}
