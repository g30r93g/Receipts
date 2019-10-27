//
//  ReceiptCell.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class ReceiptCell: UITableViewCell {
	
	// MARK: IBOutlets
	@IBOutlet weak var identifier: UILabel!
	@IBOutlet weak var dateTime: UILabel!
	@IBOutlet weak var total: RoundLabel!
	@IBOutlet weak var seenIndicator: UIView!
	
	// MARK: Methods
	func setupCell(from data: Receipts.Receipt) {
		self.identifier.text = data.identifier
		self.dateTime.text = "Quantity: \(data.date.dateValue().day()) at \(data.date.dateValue().time())"
		self.total.text = "£\(String(format: "%.2f", data.transactionDetails.total))"
		
		if data.seen {
			self.seenIndicator.alpha = 0
		} else {
			self.seenIndicator.alpha = 1
		}
	}
	
}
