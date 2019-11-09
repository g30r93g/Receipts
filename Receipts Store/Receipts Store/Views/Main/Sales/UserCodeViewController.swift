//
//  UserCodeViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit
import AVKit

class UserCodeViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var scanOutline: UIView!
	@IBOutlet weak var qrIcon: UIImageView!
	@IBOutlet weak var instructions: UILabel!
	
	// MARK: Capture Variables
	var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.setupCaptureSession()
	}
	
	// MARK: Methods
	private func showLoadingView() {
		self.qrIcon.tintColor = .systemOrange
		// TODO: - Show loading view
	}
	
	private func showBadCodeAlert() {
		let alert = UIAlertController(title: "User Not Found", message: "Please use a different QR code.", preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "Ok", style: .default) { (_) in self.dismiss(animated: true, completion: nil) })
        present(alert, animated: true)
	}
	
	private func generateReceipt(with code: String) {
		Sale.current.attatchPaymentDetails(details: [Receipts.PaymentMethod(type: .card, amount: Sale.current.total, cardNumber: 5355220212344341, cardVendor: .mastercard, creditRemaining: 0)])
		
		Sale.current.uploadReceipt(userCode: code) { (success) in
			if success {
				self.performSegue(withIdentifier: "Sale Complete", sender: self)
			} else {
				fatalError()
			}
		}
	}
	
}

// Camera Session
extension UserCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
	
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
			metadataOutput.metadataObjectTypes = [.qr]
			
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
		
		print("Started scanning QR codes")
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
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metadataObject = metadataObjects.first {
			self.stopCaptureSession()
			
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
			print("Found QR Code: \(stringValue)")

			self.showLoadingView()
			
			Authentication.account.validateCode(stringValue) { (valid) in
				if valid {
					DispatchQueue.main.async {
						self.qrIcon.tintColor = UIColor(named: "Confirm")!
						self.generateReceipt(with: stringValue)
					}
				} else {
					DispatchQueue.main.async {
						self.qrIcon.tintColor = .systemRed
						self.showBadCodeAlert()
					}
				}
			}
        }
	}
	
}
