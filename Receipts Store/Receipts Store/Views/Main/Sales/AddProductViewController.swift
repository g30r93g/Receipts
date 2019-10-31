//
//  AddProductViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit
import AVKit

class AddProductViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var camera: ScannerView!
	@IBOutlet weak var flash: RoundButton!
	@IBOutlet weak var instructions: UILabel!
	
	// MARK: Camera Variables
	var captureSession: AVCaptureSession!
	var stillImageOutput: AVCapturePhotoOutput!
	var videoPreviewLayer: AVCaptureVideoPreviewLayer!
	
	// MARK: Variables
	var flashIsOn: Bool = false
	
	// MARK: View Controller Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.camera.delegate = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if !self.camera.isRunning {
			self.camera.startCapture()
		}
	}
	
	// MARK: IBActions
	@IBAction func dismissTapped(_ sender: RoundButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func flashToggled(_ sender: RoundButton) {
		self.camera.toggleFlash()
	}

}

extension AddProductViewController: ScannerViewDelegate {
	
	func didScanBarcode(_ code: String) {
		print("Scanned Code: \(code)")
		
		Sale.current.lookupItem(from: code) { (matchedItem) in
			if let item = matchedItem {
				Sale.current.addItem(item)
			} else {
				fatalError()
				// Ask user to setup product
			}
		}
	}
	
	func scanningDidStart() {
		print("Started searching for barcodes")
	}
	
	func scanningDidFail() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func scanningDidStop() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func flashDidChange(to state: Bool) {
		if state {
			self.flash.imageView!.image = UIImage(systemName: "bolt.fill")!
		} else {
			self.flash.imageView!.image = UIImage(systemName: "bolt")!
		}
	}
	
}
