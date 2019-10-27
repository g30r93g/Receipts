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
		
		self.setupView()
    }
	
	// MARK: Methods
	private func setupView() {
		self.numberOfItems.text = "\(Sale.current.items.count) Items"
		
		var sum: Double = 0.0
		Sale.current.items.forEach({sum += ($0.price * Double($0.quantity))})
		
		self.total.text =  "£\(String(format: "%.2f", sum))"
	}
	
	// MARK: Navigation
	
	// MARK: IBActions
	
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
