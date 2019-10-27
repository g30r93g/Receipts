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

	// MARK: Variables
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.setupView()
    }
	
	// MARK: Methods
	private func setupView() {
		
	}
	
	// MARK: Navigation
	
	// MARK: IBActions
	
}

extension SalesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
		
		return cell
	}
	
}
