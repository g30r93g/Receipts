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
	@IBOutlet weak var flash: RoundButton!
	@IBOutlet weak var instructions: UILabel!
	
	// MARK: Variables
	var flashIsOn: Bool = false
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.setupView()
    }
	
	// MARK: Methods
	private func setupView() {
		
	}
	
	private func toggleFlash() {
		guard let device = AVCaptureDevice.default(for: .video) else { return }
		guard device.hasTorch else { print("Device doesn't have flash."); return }
		
		do {
			try device.lockForConfiguration()
			
			if self.flashIsOn {
				try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
				self.flash.imageView!.image = UIImage(systemName: "bolt")
			} else {
				try device.setTorchModeOn(level: 0)
				self.flash.imageView!.image = UIImage(systemName: "bolt.fill")
			}
			
			self.flashIsOn = !self.flashIsOn
			device.unlockForConfiguration()
		} catch {
			print("Flash not usable.")
		}
	}
	
	// MARK: Navigation
	
	// MARK: IBActions
	@IBAction func dismissTapped(_ sender: RoundButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func flashToggled(_ sender: RoundButton) {
		self.toggleFlash()
	}

}
