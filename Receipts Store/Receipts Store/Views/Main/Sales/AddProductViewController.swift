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
	@IBOutlet weak var lookupItem: RoundButton!
	@IBOutlet weak var flash: RoundButton!
	@IBOutlet weak var scanOutline: UIView!
	@IBOutlet weak var barcodeIcon: UIImageView!
	
	// MARK: Capture Variables
	var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
	
	// MARK: View Controller Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupCaptureSession()
	}
	
	// MARK: Methods
	private func matchItem(code: String, completion: @escaping(Sale.Item?) -> Void) {
		Sale.current.lookupItem(from: code) { (matchedItem) in completion(matchedItem) }
	}
	
	private func showLoadingView() {
		self.barcodeIcon.tintColor = UIColor(named: "Confirm")!
		// TODO: - Show loading view
	}
	
	private func indicateUnmatchedItem() {
		let alert = UIAlertController(title: "No Match Found", message: "Please make sure this product is in the UPC database.", preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "Ok", style: .default) { (_) in self.dismiss(animated: true, completion: nil) })
        present(alert, animated: true)
	}
	
	// MARK: IBActions
	@IBAction func dismissTapped(_ sender: RoundButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func toggleFlash(_ sender: UIButton) {
		self.toggleTorch()
	}
	
}

extension AddProductViewController: AVCaptureMetadataOutputObjectsDelegate {
	
	func setupCaptureSession() {
		// Initialise captureSession
		captureSession = AVCaptureSession()
		
		// Get camera access
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		
		// Attempt to set video input
		var videoInput: AVCaptureDeviceInput!
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			// Failed to set video input
			cameraSetupFailed()
		}
		
		// Assign video input to capture session if possibe
		if captureSession.canAddInput(videoInput) {
			// Success
			captureSession.addInput(videoInput)
		} else {
			// Failed
			cameraSetupFailed()
		}
		
		// Sets up scanning for capture session
		let metadataOutput = AVCaptureMetadataOutput()
		
		// Checks if the camera can scan for metadata (qr codes)
		if captureSession.canAddOutput(metadataOutput) {
			// Success
			captureSession.addOutput(metadataOutput)
			
			metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
			metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
			
		} else {
			// Failed
			cameraSetupFailed()
		}
		
		// Set the preview layer's output
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		
		// Set the preview to aspect fill
		previewLayer.videoGravity = .resizeAspectFill
		
		// Set the preview layer's bounds
		previewLayer.frame = self.view.bounds
		
		// Add preview layer to the customer preview layer.
		self.view.layer.insertSublayer(previewLayer, at: 0)
		
		// Start capturing
		self.startCaptureSession()
		
		// Add region of interest
		metadataOutput.rectOfInterest = self.previewLayer.metadataOutputRectConverted(fromLayerRect: self.scanOutline.frame)
	}
	
	func startCaptureSession() {
		if !captureSession.isRunning {
			captureSession.startRunning()
		}
	}
	
	func stopCaptureSession() {
		if captureSession.isRunning {
			captureSession.stopRunning()
		}
	}
	
	func cameraSetupFailed() {
        let alert = UIAlertController(title: "Scanning Not Supported", message: "Your device does not have a camera. This will prevent you from scanning barcodes. Please use an alternative device with a camera or service this device.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
		
        captureSession = nil
    }
	
	func toggleTorch() {
		guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
		guard device.hasTorch else { print("Torch isn't available"); return }
		
		do {
			try device.lockForConfiguration()
			device.torchMode = !device.isTorchActive ? .on : .off
			
			device.unlockForConfiguration()
		} catch {
			print("Torch can't be used")
		}
	}
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metadataObject = metadataObjects.first {
			self.stopCaptureSession()
			
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let stringValue = readableObject.stringValue else { return }
			print("Found Barcode: \(stringValue)")
			
			self.showLoadingView()
			
			self.matchItem(code: stringValue) { (item) in
				if let matchedItem = item {
					Sale.current.addItem(matchedItem)
					NotificationCenter.default.post(name: Notification.Name("UserAddedItem"), object: nil)
					
					self.dismiss(animated: true, completion: nil)
				} else {
					self.indicateUnmatchedItem()
				}
			}
		}
	}
	
}
