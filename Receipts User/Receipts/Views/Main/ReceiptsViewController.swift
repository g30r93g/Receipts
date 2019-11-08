//
//  ReceiptsViewController.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 19/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit
import Firebase

class ReceiptsViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var newReceiptNotification: UILabel!
	@IBOutlet weak var newReceiptNotificationHeight: NSLayoutConstraint!
	@IBOutlet weak var receiptPeriodSelector: UISegmentedControl!
	@IBOutlet weak var receiptTable: UITableView!
	
	@IBOutlet weak var showReceiptCode: UIButton!
	
	// MARK: Variables
	var receipts: [Receipts.Receipt] = []
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.getReceipts()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.updateNewReceiptNotifier()
	}
	
	// MARK: Methods
	private func getReceipts() {
		Receipts.current.retrieveReceipts(endDate: self.endDate().convertToTimestamp()) { (receipts) in
			print("Updating User Interface...")
			
			self.receipts = receipts
			
			self.updateNewReceiptNotifier()
			self.receiptTable.reloadData()
		}
	}
	
	private func updateNewReceiptNotifier() {
		let unreadReceiptCount = self.receipts.filter({$0.seen == false}).count
		if unreadReceiptCount > 0 {
			if unreadReceiptCount == 1 {
				self.newReceiptNotification.text = "1 New Receipt"
			} else {
				self.newReceiptNotification.text = "\(unreadReceiptCount) New Receipts"
			}
			
			UIView.animate(withDuration: 0.4) {
				self.newReceiptNotificationHeight.constant = 50.0
			}
			
			self.view.layer.layoutIfNeeded()
			self.view.layoutIfNeeded()
		} else {
			UIView.animate(withDuration: 0.4) {
				self.newReceiptNotificationHeight.constant = 0.0
			}
			
			self.view.layer.layoutIfNeeded()
			self.view.layoutIfNeeded()
		}
	}
	
	private func datesFor(days: Int) -> [String] {
		var dateStrings: [String] = []
		let calendar = Calendar(identifier: .gregorian)
		var date = calendar.today()
		
		for _ in 0...days {
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .long
			dateFormatter.timeStyle = .none
			dateStrings.append(dateFormatter.string(from: date))
			
			date = calendar.previousDay(from: date)
		}
		
		return dateStrings
	}
	
	private func endDate() -> Date {
		switch self.receiptPeriodSelector.selectedSegmentIndex {
		case 1:
			return Date().daysAgo(31)
		case 2:
			return Date().daysAgo(365)
		default:
			return Date().daysAgo(7)
		}
	}
	
	private func getMatchingDates(section: Int) -> Int {
		// Get date range of the section
		let startDate = Date().daysAgo(section + 1)
		let endDate = Date().daysAgo(section)
		let dateRange = startDate..<endDate
		
		// Filter the dates that fall in the date range
		let receiptsFallingInDateRange = self.receipts.filter({dateRange.contains($0.date.dateValue())})
		
		return receiptsFallingInDateRange.count
	}
	
	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "Show Receipt" {
			let destVC = segue.destination as! ReceiptDetailViewController
			
			guard let selectedItem = self.receiptTable.indexPathForSelectedRow?.item else { fatalError() }
			destVC.receipt = self.receipts[selectedItem]
		}
	}
	
	// MARK: IBActions
	@IBAction func segmentChanged(_ sender: UISegmentedControl) {
		self.receiptTable.reloadData()
	}
	
	@IBAction func showUserCode(_ sender: UIButton) {
		self.performSegue(withIdentifier: "Show User Code", sender: nil)
	}
	
	@IBAction func refreshTapped(_ sender: UIBarButtonItem) {
		self.getReceipts()
	}
	
}

// MARK: Table View Delegates
extension ReceiptsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.receipts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Receipt", for: indexPath) as! ReceiptCell
		let data = self.receipts[indexPath.row]
		
		cell.setupCell(from: data)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "Show Receipt", sender: self)
	}
	 
}
