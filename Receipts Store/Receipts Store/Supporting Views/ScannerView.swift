//
//  ScannerView.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 27/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import UIKit
import AVKit

protocol ScannerViewDelegate: class {
	func didScanQRCode(_ code: String)
	func didScanBarcode(_ code: String)
	func flashDidChange(to state: Bool)
	func scanningDidStart()
	func scanningDidFail()
	func scanningDidStop()
}

extension ScannerViewDelegate {
	
	func didScanQRCode(_ code: String) {}
	func didScanBarcode(_ code: String) {}
	func flashDidChange(to state: Bool) {}
	func scanningDidStart() {}
	
}

class ScannerView: UIView {
	
	// MARK: Delegates
	weak var delegate: ScannerViewDelegate?
	
	// MARK: Stored Variables
	override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
	
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
	
	// MARK: Variables
	var captureSession: AVCaptureSession?
	
	var flashIsOn: Bool = false
	
	var isRunning: Bool {
		return self.captureSession?.isRunning ?? false
	}
	
	// MARK: Initialisers
	required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
		self.setupView()
    }
	
    override init(frame: CGRect) {
        super.init(frame: frame)
		
		self.setupView()
    }
	
	// MARK: Methods
	private func setupView() {
		self.clipsToBounds = true
		self.captureSession = AVCaptureSession()
		
		self.startScanning()
	}
	
	private func startScanning() {
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		
		let videoInput: AVCaptureDeviceInput
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch let error {
			print(error)
			return
		}
		
		if (captureSession?.canAddInput(videoInput) ?? false) {
			captureSession?.addInput(videoInput)
		} else {
			scanningDidFail()
			return
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
		self.delegate?.scanningDidStart()
	}
	
	func toggleFlash() {
		guard let device = AVCaptureDevice.default(for: .video) else { return }
		guard device.hasTorch else { print("Device doesn't have flash."); return }
		
		do {
			try device.lockForConfiguration()
			
			if !self.flashIsOn {
				try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
				self.delegate?.flashDidChange(to: true)
			} else {
				try device.setTorchModeOn(level: 0)
				self.delegate?.flashDidChange(to: false)
			}
			
			self.flashIsOn = !self.flashIsOn
			device.unlockForConfiguration()
		} catch {
			print("Flash not usable.")
		}
	}
	
	// MARK: Delegate Methods
	func scanningDidFail() {
		self.delegate?.scanningDidFail()
		captureSession = nil
	}
	
}

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let scannedString = readableObject.stringValue else { return }
			
			switch readableObject.type {
			case .qr:
				self.delegate?.didScanQRCode(scannedString)
			case .ean13, .upce:
				self.delegate?.didScanBarcode(scannedString)
			default:
				break
			}
        }
    }
	
}
