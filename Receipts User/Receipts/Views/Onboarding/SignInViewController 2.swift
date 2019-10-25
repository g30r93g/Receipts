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
		guard let email = self.emailText.text else { fatalError() }
		guard let password = self.passwordText.text else { fatalError() }
		
//		Authentication.account.signIn() { (result)
//			switch result {
//			case .success:
//				print("SignInViewController - Sign In Successful")
//				self.performSegue(withIdentifier: "Sign In Successful", sender: self)
//			case .failure(let error):
//				print("SignInViewController - Error Signing In: \(error)")
//			}
//		}
	}
	
	private func forgotPassword() {
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
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// TODO: - Bring Sign In button above keyboard
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		// TODO: - Return Sign In button to original position
	}
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailText {
            // Move from username to password
            self.passwordText.becomeFirstResponder()
        } else if textField == self.passwordText {
            // Sign In
			// TODO: - Precheck the email and password fields
			self.signIn()
		} else {
			 return false
		}
        
        return true
    }
	
}
