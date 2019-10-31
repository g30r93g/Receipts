//
//  CompleteSignUpViewController.swift
//  Receipts
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
	
	// MARK: View Controller Life Cycle
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.sendVerificationEmail()
	}
	
	// MARK: Methods
	private func sendVerificationEmail() {
		self.startLoading()
		
		Authentication.account.sendEmailVerification { (success) in
			if success {
				self.verified()
			} else {
				fatalError()
			}
		}
	}
	
	private func resendVerificationEmail() {
		if Date() > lastSentDate.adding(seconds: 60) {
			self.sendVerificationEmail()
		}
		
		self.lastSentDate = Date()
	}
	
	private func verified() {
		if self.openMail == nil { return }
		print("User verified!")
		self.stopLoading()
		
		self.performSegue(withIdentifier: "Sign Up Successful", sender: self)
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
