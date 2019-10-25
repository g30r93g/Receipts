//
//  SignInViewController.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 18/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var signInIndicator: UIActivityIndicatorView!
	@IBOutlet weak var emailText: ImageTextField!
	@IBOutlet weak var passwordText: ImageTextField!
	@IBOutlet weak var forgotPasswordButton: UIButton!
	@IBOutlet weak var signInButton: RoundButton!
	@IBOutlet weak var signUpButton: RoundButton!
	
	// MARK: Variables
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	// MARK: Methods
	private func signIn() {
		self.startLoading()
		
		guard let email = self.emailText.text else { fatalError() }
		guard let password = self.passwordText.text else { fatalError() }
		
		Authentication.account.signIn(email: email, password: password) { (success) in
			if success {
				// Check if user is authenticated
				if Authentication.account.isVerified {
					self.performSegue(withIdentifier: "Sign In Successful", sender: self)
				} else {
					self.performSegue(withIdentifier: "Verify Email", sender: self)
				}
			} else {
				fatalError()
			}
		}
		
		self.stopLoading()
	}
	
	private func forgotPassword() {
		let alert = UIAlertController(title: "Forgot Password", message: "Please enter your email to reset your password.", preferredStyle: .alert)
		
		alert.addTextField { (textField) in
			textField.placeholder = "Email"
			textField.keyboardType = .emailAddress
			textField.keyboardAppearance = .dark
			textField.returnKeyType = .continue
			textField.becomeFirstResponder()
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .default))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	private func startLoading() {
		self.signInIndicator.startAnimating()
	}
	
	private func stopLoading() {
		self.signInIndicator.stopAnimating()
	}
	
	// MARK: IBActions
	@IBAction func signInTapped(_ sender: UIButton) {
		self.signIn()
	}
	
	@IBAction func signUpTapped(_ sender: UIButton) {
		self.performSegue(withIdentifier: "Sign Up", sender: self)
	}
	
	@IBAction func forgotPasswordTapped(_ sender: UIButton) {
		self.forgotPassword()
	}

}

extension SignInViewController: UITextFieldDelegate {
	
	private func textFieldDidBeginEditing(_ textField: ImageTextField) {
		// TODO: - Bring Sign In button above keyboard
		textField.borderColor = UIColor(named: "Secondary Accent")!
		textField.setNeedsDisplay()
	}
	
	private func textFieldDidEndEditing(_ textField: ImageTextField) {
		// TODO: - Return Sign In button to original position
		textField.borderColor = .white
		textField.setNeedsDisplay()
	}
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailText {
            // Move from username to password
            self.passwordText.becomeFirstResponder()
        } else if textField == self.passwordText {
            // Sign In
			// TODO: - Precheck the email and password fields
			self.signIn()
            self.passwordText.resignFirstResponder()
		} else {
			 return false
		}
        
        return true
    }
	
}
