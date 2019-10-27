//
//  PaymentViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var cashTotal: RoundLabel!
	@IBOutlet weak var setCash: RoundButton!
	@IBOutlet weak var cardTotal: RoundLabel!
	@IBOutlet weak var setCard: RoundButton!
	
	@IBOutlet weak var cashBreakdown: UILabel!
	@IBOutlet weak var cardBreakdown: UILabel!
	@IBOutlet weak var totalBreakdown: UILabel!
	@IBOutlet weak var payButton: RoundButton!
	
	// MARK: Variables
	var cashAmount: Double = 0.0 {
		didSet {
			let cashText = String(format: "%.2f", self.cashAmount)
			self.cashTotal.text = "£\(cashText)"
			self.cashBreakdown.text = "£\(cashText)"
		}
	}
	var cardAmount: Double = 0.0 {
		didSet {
			let cardText = String(format: "%.2f", self.cardAmount)
			self.cashTotal.text = "£\(cardText)"
			self.cashBreakdown.text = "£\(cardText)"
		}
	}
	var totalAmount: Double = 0.0 {
		didSet {
			let totalText = String(format: "%.2f", self.cashAmount + self.cardAmount)
			self.totalBreakdown.text = "£\(totalText)"
		}
	}

	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.setupView()
    }
	
	// MARK: Enums
	enum PaymentType: String {
		case cash = "Cash"
		case card = "Card"
	}
    
	// MARK: Methods
	private func setupView() {
		
	}
	
	private func displayEntryField(for paymentType: PaymentType) {
		let alert = UIAlertController(title: "Enter \(paymentType.rawValue) value", message: nil, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: nil))
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	// MARK: Navigation
	
	// MARK: IBActions
	@IBAction func enterAmountTapped(_ sender: RoundButton) {
		if sender == setCash {
			self.displayEntryField(for: .cash)
		} else if sender == setCard {
			self.displayEntryField(for: .card)
		} else {
			fatalError()
		}
	}
	
	@IBAction func payTapped(_ sender: RoundButton) {
		
	}

}
