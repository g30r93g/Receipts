//
//  Authentication.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 18/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class Authentication {
	
	// MARK: Shared Instance
	static let account = Authentication()
	
	// MARK: Enums
	enum UserDetails {
		case name
		case email
		case phoneNumber
	}
	
	// MARK: Storage Variables
	private let storage = Storage.storage()
	
	// MARK: Auth Variables
    private let auth = Auth.auth()
	
	// MARK: Auth Data Variables
	var uniqueIdentifier: String {
		if self.isSignedIn {
			return self.auth.currentUser!.uid
		} else {
			return ""
		}
	}
	
	var isSignedIn: Bool {
		return self.auth.currentUser != nil
	}
	
	/// Determines if the user is verified
	var isVerified: Bool {
		if self.isSignedIn {
			return self.auth.currentUser!.isEmailVerified
		} else {
			return false
		}
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
        } catch let error as NSError {
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
			guard let userDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier) else { return }
			
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
				if let error = error {
					fatalError("\(error)")
					completion(false)
				} else {
					completion(true)
				}
			}
		} else {
			fatalError("User isn't signed in, therefore couldn't send verification.")
			completion(false)
		}
    }
	
	// MARK: Firestore Variables
	private let data = Firestore.firestore()
	
	// MARK: Firestore Methods
	/// Stores user's details
    func storeUserDetails(name: String, email: String, phoneNumber: String, completion: @escaping(Bool) -> Void) {
		guard let userDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier) else { completion(false); return }
		
		userDocument.setData(["storeName": name, "email": email, "phoneNumber": phoneNumber, "receipts": [], "newReceipts": [], "prefs" : ["pushNotifs": true, "emailNotifs": false]], merge: false) { (error) in
			if let error = error {
				fatalError("\(error)")
				completion(false)
				return
			} else {
				completion(true)
			}
		}
	}
	
	// Get's user information
	func getUserInfo(type: UserDetails, completion: @escaping(String) -> Void) {
		if self.isSignedIn {
			guard let userDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier) else { return }
			
			switch type {
			case .name:
				userDocument.getDocument { (document, error) in
					if let error = error {
						fatalError("\(error)")
						return
					} else if let document = document {
						completion(document.get("storeName") as! String)
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
	
	func uploadImage(image: UIImage, completion: @escaping(Bool) -> Void) {
		guard let image = image.pngData() else { fatalError(); completion(false) }
		
		let imageStorage = self.storage.reference().child("Store Logos/\(self.uniqueIdentifier)")
		
		imageStorage.putData(image, metadata: nil) { (metadata, error) in
			if let error = error {
				fatalError("\(error)")
				completion(false)
			} else {
				
			}
		}
	}
	
}
