//
//  SalesViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class SalesViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var numberOfItems: UILabel!
	@IBOutlet weak var itemsTable: UITableView!
	@IBOutlet weak var addItem: RoundButton!
	@IBOutlet weak var checkout: RoundButton!
	@IBOutlet weak var total: UILabel!
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name("ItemsDidChange"), object: nil)
		self.updateView()
    }
	
	// MARK: Methods
	@objc private func updateView() {
		switch Sale.current.numberOfItems {
		case 0:
			self.numberOfItems.text = "No Items"
		case 1:
			self.numberOfItems.text = "1 Item"
		default:
			self.numberOfItems.text = "\(Sale.current.numberOfItems) Items"
		}
		
		self.total.text =  "£\(String(format: "%.2f", Sale.current.total))"
		self.itemsTable.reloadData()
	}
	
	// MARK: Navigation
	
	// MARK: IBActions
	@IBAction func processAnotherSale(_ sender: UIStoryboardSegue) {
		
	}
	
}

extension SalesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Sale.current.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
		let data = Sale.current.items[indexPath.row]
		
		cell.setupCell(from: data)
		
		return cell
	}
	
}
