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

extension ReceiptsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Receipt", for: indexPath) as! ReceiptCell
		
		return cell
	}
	
}
