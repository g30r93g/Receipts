//
//  BorderedTableCell.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 20/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BorderedTableCell: UITableViewCell {
	
	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
		}
	}
	
	@IBInspectable var borderWidth: CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = self.borderWidth
		}
	}
	
	 @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
		didSet {
			layer.borderColor = borderColor.cgColor
		}
	}
	
}
