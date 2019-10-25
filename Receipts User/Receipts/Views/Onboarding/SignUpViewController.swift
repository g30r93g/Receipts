//
//  SignUpViewController.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 18/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var dismissButton: UIButton!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var nameText: ImageTextField!
	@IBOutlet weak var phoneNumberText: ImageTextField!
	@IBOutlet weak var emailText: ImageTextField!
	@IBOutlet weak var passwordText: ImageTextField!
	@IBOutlet weak var continueButton: RoundButton!
	
	// MARK: View Controller Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.nameText.delegate = self
		self.phoneNumberText.delegate = self
		self.emailText.delegate	= self
		self.passwordText.delegate = self
		
		self.nameText.becomeFirstResponder()
	}
	
	// MARK: Methods
	private func signUp() {
		self.startLoading()
		
		guard let name = self.nameText.text else { fatalError() }
		guard let phoneNumber = self.phoneNumberText.text else { fatalError() }
		guard let email = self.emailText.text else { fatalError() }
		guard let password = self.passwordText.text else { fatalError() }
		
		Authentication.account.signUp(name: name, email: email, password: password, phoneNumber: phoneNumber) { (success) in
			if success {
				self.performSegue(withIdentifier: "Verify Email", sender: self)
			} else {
				fatalError()
			}
			
			self.stopLoading()
		}
	}
	
	private func startLoading() {
		self.loadingIndicator.startAnimating()
	}
	
	private func stopLoading() {
		self.loadingIndicator.stopAnimating()
	}
	
	// MARK: IBActions
	@IBAction func continueTapped(_ sender: UIButton) {
		self.signUp()
	}
	
	@IBAction func dismissTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
}

extension SignUpViewController: UITextFieldDelegate {
	
	private func textFieldDidBeginEditing(_ textField: ImageTextField) {
		textField.borderColor = UIColor(named: "Secondary Accent")!
	}
	
	private func textFieldDidEndEditing(_ textField: ImageTextField) {
		textField.borderColor = .white
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.nameText {
			// Move from name to phone number
			self.phoneNumberText.becomeFirstResponder()
		} else if textField == self.phoneNumberText {
			// Move from phone number to email
			self.emailText.becomeFirstResponder()
		} else if textField == self.emailText {
			// Move from email to password
			self.passwordText.becomeFirstResponder()
		} else if textField == self.passwordText {
			// Continue Sign Up
			self.signUp()
			self.passwordText.resignFirstResponder()
		} else {
			return false
		}
		
		return true
	}
	
}

