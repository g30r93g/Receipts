//
//  ReceiptItem.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 25/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class ReceiptItem: RoundUICollectionViewCell {
	
	// MARK: IBOutlets
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var quantity: UILabel!
	@IBOutlet weak var price: UILabel!
	
	// MARK: Methods
	func setupCell(from data: Receipts.Item) {
		self.name.text = data.name
		self.quantity.text = "Quantity: \(data.quantity)"
		self.price.text = "£\(String(format: "%.2f", data.price))"
	}
	
}

