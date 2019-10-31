//
//  UserCodeViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class UserCodeViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var camera: ScannerView!
	@IBOutlet weak var flash: RoundButton!
	@IBOutlet weak var instructions: UILabel!
	
	// MARK: Variables
	var userCode: String!
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
	}
	
	// MARK: Methods
	func validateCode(_ code: String, completion: @escaping(Bool) -> Void) {
		completion(false)
	}
	
	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "Sale Complete" {
			let destVC = segue.destination as! SaleCompleteViewController
			
			destVC.userIdentifier = userCode
		}
	}
	
	// MARK: IBActions
	@IBAction func flashToggled(_ sender: RoundButton) {
		self.camera.toggleFlash()
	}

}

extension UserCodeViewController: ScannerViewDelegate {
	
	func didScanQRCode(_ code: String) {
		self.validateCode(code) { (success) in
			if success {
				Sale.current.uploadReceipt(userCode: code) { (success) in
					if success {
						self.userCode = code
						self.performSegue(withIdentifier: "Sale Complete", sender: nil)
					} else {
						fatalError("Unable to generate receipt.")
					}
				}
			} else {
				fatalError("No user with code \(code) exists.")
			}
		}
	}
	
	func scanningDidFail() {
		fatalError()
	}
	
	func scanningDidStop() {
		print("Scanning stopped...")
	}
	
}
