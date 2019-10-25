//
//  CodeViewController.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 28/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class CodeViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var dismiss: RoundButton!
	@IBOutlet weak var userCode: RoundImageView!
	
	// MARK: Variables
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.generateUserCode()
	}
	
	// MARK: Methods
	func generateUserCode() {
		let userCode = Authentication.account.uniqueIdentifier.data(using: .ascii)
		
		// Generate QR Code
		guard let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator") else { fatalError() }
		qrCodeFilter.setValue(userCode, forKey: "inputMessage")
		guard let qrCode = qrCodeFilter.outputImage else { fatalError() }
		
		// Invert QR Code Colors
		guard let qrCodeInverter = CIFilter(name: "CIColorInvert") else { fatalError() }
		qrCodeInverter.setValue(qrCode, forKey: "inputImage")
		guard let invertedQrCode = qrCodeInverter.outputImage else { fatalError() }
		
		// Set background alpha to 0 (remove background)
		guard let qrCodeMasker = CIFilter(name: "CIMaskToAlpha") else { return }
		qrCodeMasker.setValue(invertedQrCode, forKey: "inputImage")
		guard let finalQrCode = qrCodeMasker.outputImage else { return }
		
		// Set user's QR code
		self.userCode.image = UIImage(ciImage: finalQrCode.transformed(by: CGAffineTransform(scaleX: 100, y: 100)))
	}
	
	// MARK: IBActions
	@IBAction func dismissTapped(_ sender: RoundButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
}
