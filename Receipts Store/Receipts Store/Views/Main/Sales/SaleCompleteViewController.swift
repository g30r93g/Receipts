//
//  SaleCompleteViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class SaleCompleteViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var userID: UILabel!
	@IBOutlet weak var receiptID: UILabel!
	
	@IBOutlet weak var processSale: RoundButton!
	@IBOutlet weak var viewReceipt: RoundButton!
	
	// MARK: Variables
	var userIdentifier: String!
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.setupView()
    }
    
	// MARK: Methods
	private func setupView() {
		self.userID.text = "User ID: \(self.userIdentifier!)"
		self.receiptID.text = "Receipt ID: \(Sale.current.receipt.identifier)"
	}

}
