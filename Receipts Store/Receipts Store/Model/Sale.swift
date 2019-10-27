//
//  Sale.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation

class Sale {
	
	// MARK: Shared Instance
	static let current = Sale()
	
	// MARK: Initialisers
	init() {
		self.items = []
		self.payment = []
		self.saleID = ""
		
		generateSaleID()
	}
	
	// MARK: Variables
	private var saleID: String
	private(set) var items: [Item]
	private(set) var payment: [Receipts.PaymentMethod]
	private(set) var receipt: Receipts.Receipt!
	
	var total: Double {
		return self.items.map({$0.price * Double($0.quantity)}).reduce(0, {$0 + $1})
	}
	
	// MARK: Methods
	private func generateSaleID() {
		self.saleID = ""
	}
	
	func addItem(_ item: Item) {
		self.items.insert(item, at: 0)
	}
	
	func removeItem(at index: Int) {
		self.items.remove(at: index)
	}
	
	func attatchPaymentDetails(details: [Receipts.PaymentMethod]) {
		self.payment = details
	}
	
	func lookupItem(from barcode: String, callback: @escaping(Item?) -> Void) {
		callback(nil)
	}
	
	func generateReceipt(callback: @escaping(Bool) -> Void) {
		callback(false)
	}
	
	// MARK: Structs
	struct Item {
		let name: String
		let price: Double
		var quantity: Int
		
		mutating func updateQuantity(to newQuantity: Int) {
			self.quantity = newQuantity
		}
	}
	
}
