//
//  CompleteSignUpViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 19/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class CompleteSignUpViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var openMail: UIButton!
	@IBOutlet weak var resendEmail: UIButton!
	@IBOutlet weak var emailVerificationLoading: UIActivityIndicatorView!
	
	// MARK: Variables
	var lastSentDate: Date = Date()
	var alreadyVerified: Bool = false
	
	// MARK: View Controller Life Cycle
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.sendVerificationEmail()
	}
	
	// MARK: Methods
	private func sendVerificationEmail() {
		self.startLoading()
		
		if self.alreadyVerified { return }
		Authentication.account.sendEmailVerification { (success) in
			if self.alreadyVerified { return }
			if success {
				print("Verified user's email!")
				self.stopLoading()
				self.alreadyVerified = true

				if !self.alreadyVerified {
					self.performSegue(withIdentifier: "Upload Logo", sender: nil)
				}
			} else {
				fatalError("Could not verify user email.")
			}
		}
	}
	
	private func resendVerificationEmail() {
		if Date() > self.lastSentDate.adding(seconds: 20) {
			self.sendVerificationEmail()
		}
		
		self.lastSentDate = Date()
	}
	
	private func startLoading() {
		self.emailVerificationLoading.startAnimating()
	}
	
	private func stopLoading() {
		self.emailVerificationLoading.stopAnimating()
	}
	
	// MARK: IBActions
	@IBAction func openMailTapped(_ sender: UIButton) {
		let mailApp: URL = URL(string: "message://")!
		
		if UIApplication.shared.canOpenURL(mailApp) {
			UIApplication.shared.open(mailApp, options: [:], completionHandler: nil)
		}
	}
	
	@IBAction func resendEmailTapped(_ sender: UIButton) {
		self.resendVerificationEmail()
	}
	
}
