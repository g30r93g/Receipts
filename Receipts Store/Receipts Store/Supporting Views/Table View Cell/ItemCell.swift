//
//  ItemCell.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
	
	// MARK: IBOutlets
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var quantity: UILabel!
	@IBOutlet weak var price: RoundLabel!
	
	// MARK: Methods
	func setupCell(from data: Receipts.Item) {
		self.name.text = data.name
		self.quantity.text = "Quantity: \(data.quantity)"
		self.price.text = "£\(String(format: "%.2f", data.price))"
	}
	
}
