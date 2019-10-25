//
//  ReceiptCell.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 25/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

@IBDesignable
class ReceiptCell: RoundUITableViewCell {
	
	// MARK: IBInspectables
	@IBInspectable var borderWidth: CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = self.borderWidth
		}
	}
	
	 @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
		didSet {
			self.layer.borderColor = self.borderColor.cgColor
		}
	}
	
	// MARK: IBOutlets
	@IBOutlet weak var storeImage: RoundImageView!
	@IBOutlet weak var storeName: UILabel!
	@IBOutlet weak var receiptTime: UILabel!
	@IBOutlet weak var cost: RoundLabel!
	
	@IBOutlet weak var notificationIndicator: RoundView!
	
	// MARK: Methods
	func setupCell(from data: Receipts.Receipt) {
		self.storeName.text = data.storeDetails.name
		self.receiptTime.text = "\(data.date.dateValue().day()) at \(data.date.dateValue().time())"
		self.cost.text = "£\(String(format: "%.2f", data.transactionDetails.total))"
		
		self.retrieveStoreImage(storeID: data.storeDetails.uid)
		
		self.setSeen(to: data.seen)
	}
	
	private func retrieveStoreImage(storeID: String) {
		// Send request to firebase storage to get store logo
		
	}
	
	func setSeen(to seen: Bool = true) {
		if seen {
			self.notificationIndicator.alpha = 0
		} else {
			self.notificationIndicator.alpha = 1
		}
	}
	
}
