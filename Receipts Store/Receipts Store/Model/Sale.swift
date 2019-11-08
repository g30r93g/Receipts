//
//  Sale.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Sale {
	
	// MARK: Shared Instance
	static let current = Sale()
	
	// MARK: Initialisers
	init() {
		self.items = []
		self.payment = []
		self.userCode = ""
	}
	
	// MARK: Variables
	private(set) var userCode: String
	private(set) var items: [Item] {
		didSet {
			NotificationCenter.default.post(name: Notification.Name("ItemsDidChange"), object: nil)
		}
	}
	private(set) var payment: [Receipts.PaymentMethod]
	private(set) var receipt: Receipts.Receipt!
	
	var total: Double {
		return self.items.map({$0.price * Double($0.quantity)}).reduce(0, {$0 + $1})
	}
	
	var numberOfItems: Int {
		return self.items.map({$0.quantity}).reduce(0, {$0 + $1})
	}
	
	// MARK: Structs
	struct Item: Equatable {
		let uuid: String
		let name: String
		let price: Double
		var quantity: Int
		
		mutating func updateQuantity(to newQuantity: Int) {
			self.quantity = newQuantity
		}
		
		static func == (lhs: Item, rhs: Item) -> Bool {
			return lhs.uuid == rhs.uuid
		}
	}
	
	// MARK: Methods
	func addItem(_ item: Item) {
		if let existingIndex = self.items.firstIndex(where: {$0 == item}) {
			var newItem = self.items.remove(at: existingIndex)
			newItem.updateQuantity(to: item.quantity + 1)
			self.items.insert(newItem, at: 0)
		} else {
			self.items.insert(item, at: 0)
		}
	}
	
	func removeItem(at index: Int) {
		self.items.remove(at: index)
	}
	
	func attatchPaymentDetails(details: [Receipts.PaymentMethod]) {
		self.payment = details
	}
	
	func lookupItem(from barcode: String, completion: @escaping(Item?) -> Void) {
		let itemsReference: DocumentReference = Receipts.current.data.collection("Products").document(barcode)
		
		itemsReference.getDocument { (document, error) in
			if error != nil {
				completion(nil)
			} else if let data = document?.data() {
				completion(Item(uuid: barcode, name: data["name"] as! String, price: data["price"] as! Double, quantity: 1))
			} else {
				completion(nil)
			}
		}
	}
	
	func uploadReceipt(userCode: String, completion: @escaping(Bool) -> Void) {
		Receipts.current.uploadSalesReceipt(sale: self) { (receipt) in
			if let receipt = receipt {
				self.userCode = userCode
				self.receipt = receipt
				
				completion(true)
			} else {
				completion(false)
			}
		}
	}
	
	func reset() {
		self.items.removeAll()
		self.payment.removeAll()
		self.userCode = ""
		self.receipt = nil
	}
	
}
