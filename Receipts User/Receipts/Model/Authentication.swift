//
//  Authentication.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 18/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Authentication {
	
	// MARK: Shared Instance
	static let account = Authentication()
	
	// MARK: Enums
	enum UserDetails {
		case name
		case email
		case phoneNumber
	}
	
	// MARK: Auth Variables
    let auth = Auth.auth()
	
	// MARK: Auth Data Variables
	var uniqueIdentifier: String {
		return self.auth.currentUser?.uid ?? ""
	}
	
	var isSignedIn: Bool {
		return self.auth.currentUser != nil
	}
	
	/// Determines if the user is verified
	var isVerified: Bool {
		guard let user = self.auth.currentUser else { return false }
		user.reload()
		
		return self.auth.currentUser?.isEmailVerified ?? false
	}
	
	// MARK: Auth Methods
    /// Performs sign in sequence
	func signIn(email: String, password: String, completion: @escaping(Bool) -> Void) {
		self.auth.signIn(withEmail: email, password: password) { (user, error) in
			if let error = error, let authErr = AuthErrorCode(rawValue: error._code) {
				var message: String = ""
				
				switch authErr {
				case .invalidCredential:
					message = "Please check your email and password."
				case .userDisabled:
					message = "Your account has been disabled. Please contact us for more information."
				case .operationNotAllowed:
					message = "Operation denied."
				case .invalidEmail:
					message = "Your email is not valid."
				case .wrongPassword:
					message = "Your password is incorrect."
				case .tooManyRequests:
					message = "You've sent too many sign in requests. Please try later."
				case .userNotFound:
					message = "This account does not exist."
				case .networkError:
					message = "No network connection."
				case .sessionExpired:
					message = "You have been logged out due to your session expiring."
				case .quotaExceeded:
					message = "Your authentication service quota has been exceeded."
				case .keychainError:
					message = "A keychain error has occurred. Please try later."
				case .internalError:
					message = "An internal error has occurred. Please try later."
				default:
					break
				}
				
				print(message)
				
				completion(false)
			} else {
				print("User signed in! - \(user!)")
				completion(true)
			}
        }
    }
    
    /// Perform sign up sequence
	func signUp(name: String, email: String, password: String, phoneNumber: String, completion: @escaping(Bool) -> Void) {
		self.auth.createUser(withEmail: email, password: password) { (result, error) in
			if let error = error {
				fatalError("\(error)")
				completion(false)
			} else {
				self.auth.currentUser!.createProfileChangeRequest().displayName = name
				
				self.storeUserDetails(name: name, email: email, phoneNumber: phoneNumber) { (success) in
					completion(success)
				}
			}
		}
    }
    
    /// Peforms user sign out
    func signOut(completion: @escaping(Bool) -> Void) {
        do {
			try self.auth.signOut()
            print("Debug: User signed out successfully with no errors.")
            
            completion(true)
        } catch let error {
            fatalError("\(error)")
            completion(false)
        }
    }
	
	/// Reauthenticates user
	private func reauthenticate(oldPassword: String, completion: @escaping(Bool) -> ()) {
		if self.isSignedIn {
			let credential = EmailAuthProvider.credential(withEmail: self.auth.currentUser!.email!, password: oldPassword)
			self.auth.currentUser!.reauthenticateAndRetrieveData(with: credential) { (result, error) in
				if let error = error {
					completion(false)
				} else if let result = result {
					completion(true)
				} else {
					completion(false)
				}
			}
		} else {
			fatalError()
			completion(false)
		}
	}
	
    /// Sends a password reset request
    func sendPasswordReset(email: String, completion: @escaping(Bool) -> Void) {
		self.auth.sendPasswordReset(withEmail: email) { (error) in
			if let error = error {
				fatalError("\(error)")
				completion(false)
			} else {
				completion(true)
			}
        }
    }
	
	/// Sends a code to update a password
	func updatePassword(oldPassword: String, newPassword: String, completion: @escaping(Bool) -> Void) {
		self.reauthenticate(oldPassword: oldPassword) { (success) in
			if success {
				self.auth.currentUser!.updatePassword(to: newPassword) { (error) in
					if let _ = error {
						completion(false)
					} else {
						completion(true)
					}
				}
			} else {
				completion(false)
			}
		}
	}
	
	/// Sends a code to update a password
	func updatePhoneNumber(newNumber: String, completion: @escaping(Bool) -> Void) {
		if self.isSignedIn {
			let userDocument: DocumentReference = data.collection("Users").document(Authentication.account.uniqueIdentifier)
			
			userDocument.setData(["phoneNumber" : newNumber], merge: true) { (error) in
				if let error = error {
					fatalError("\(error)")
					completion(false)
				} else {
					completion(true)
				}
			}
		} else {
			fatalError()
			completion(false)
		}
	}
	
    /// Sends an email for user to verify their account
	func sendEmailVerification(completion: @escaping(Bool) -> Void) {
		if self.isSignedIn {
			self.auth.currentUser!.sendEmailVerification { (error) in
				if error != nil {
					completion(false)
				} else {
					self.monitorVerifiedStatus { (verified) in
						completion(verified)
					}
				}
			}
		} else {
			completion(false)
		}
    }
	
	private func monitorVerifiedStatus(completion: @escaping(Bool) -> Void) {
		Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
			print("User verification is \(self.isVerified)")
			
			if self.isVerified {
				timer.invalidate()
				completion(true)
			}
		}.fire()
	}
	
	// MARK: Firestore Variables
	var data = Firestore.firestore()
	
	// MARK: Firestore Methods
	/// Stores user's details
    func storeUserDetails(name: String, email: String, phoneNumber: String, completion: @escaping(Bool) -> Void) {
		let userDocument: DocumentReference = data.collection("Users").document(Authentication.account.uniqueIdentifier)
		
		userDocument.setData(["name": name, "email": email, "phoneNumber": phoneNumber, "receipts": [], "newReceipts": [], "prefs" : ["pushNotifs": true, "emailNotifs": false]], merge: false) { (error) in
			if let error = error {
				fatalError("\(error)")
				completion(false)
				return
			} else {
				completion(true)
			}
		}
	}
	
	// Update User Prefs
	func updateUserPrefs(prefs: [String : Bool], completion: @escaping(Bool) -> Void) {
		let userDocument: DocumentReference = data.collection("Users").document(Authentication.account.uniqueIdentifier)
		
		userDocument.setData(["prefs" : prefs], merge: true) { (error) in
			if let error = error {
				fatalError("\(error)")
				completion(false)
			} else {
				completion(true)
			}
		}
	}
	
	// Get's user information
	func getUserInfo(type: UserDetails, completion: @escaping(String) -> Void) {
		if self.isSignedIn {
			let userDocument: DocumentReference = data.collection("Users").document(Authentication.account.uniqueIdentifier)
			
			switch type {
			case .name:
				userDocument.getDocument { (document, error) in
					if let error = error {
						fatalError("\(error)")
						return
					} else if let document = document {
						completion(document.get("name") as! String)
					}
				}
			case .email:
				completion(self.auth.currentUser!.email!)
			case .phoneNumber:
				userDocument.getDocument { (document, error) in
					if let error = error {
						fatalError("\(error)")
						return
					} else if let document = document {
						completion(document.get("phoneNumber") as! String)
					}
				}
			}
		} else {
			fatalError()
			return
		}
	}
	
}
