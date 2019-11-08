//
//  ReceiptsViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class ReceiptsViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var receiptsTable: UITableView!
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.updateReceipts()
    }
    
	// MARK: Methods
	private func updateReceipts() {
		Receipts.current.retrieveReceipts() { (_) in
			self.receiptsTable.reloadData()
		}
	}
	
	// MARK: IBActions
	@IBAction func viewReceipts(_ sender: UIStoryboardSegue) { }
	
	@IBAction func refreshTapped(_ sender: UIBarButtonItem) {
		self.updateReceipts()
	}
	
}

extension ReceiptsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Receipts.current.receipts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Receipt", for: indexPath) as! ReceiptCell
		let data = Receipts.current.receipts[indexPath.row]
		
		cell.setupCell(from: data)
		
		return cell
	}
	
}
