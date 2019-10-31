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
	
	// MARK: Structs
	struct Store {
		let name: String
		let email: String
		let phoneNumber: String
		var logo: UIImage!
		
		mutating func addLogo(_ image: UIImage) {
			self.logo = image
		}
	}
	
	// MARK: Storage Variables
	private let storage = Storage.storage()
	
	// MARK: Auth Variables
    private let auth = Auth.auth()
	
	// MARK: Auth Data Variables
	var storeDetails: Store!
	
	var uniqueIdentifier: String {
		return self.auth.currentUser?.uid ?? ""
	}
	
	/// Determines if user is signed in
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
				self.updateDetails()
				
				completion(true)
			}
        }
    }
    
    /// Perform sign up sequence
	func signUp(name: String, email: String, password: String, phoneNumber: String, completion: @escaping(Bool) -> Void) {
		self.auth.createUser(withEmail: email, password: password) { (result, error) in
			if let error = error {
				print("\(error)")
				completion(false)
			} else {
				self.auth.currentUser!.createProfileChangeRequest().displayName = name
				
				self.uploadStoreDetails(name: name, email: email, phoneNumber: phoneNumber) { (success) in
					completion(success)
				}
				
				self.storeDetails = Store(name: name, email: email, phoneNumber: phoneNumber, logo: nil)
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
			print("\(error)")
            completion(false)
        }
    }
	
	/// Reauthenticates user
	private func reauthenticate(oldPassword: String, completion: @escaping(Bool) -> ()) {
		if self.isSignedIn {
			let credential = EmailAuthProvider.credential(withEmail: self.auth.currentUser!.email!, password: oldPassword)
			self.auth.currentUser!.reauthenticateAndRetrieveData(with: credential) { (result, error) in
				completion(error == nil && result != nil)
			}
		} else {
			completion(false)
		}
	}
	
    /// Sends a password reset request
    func sendPasswordReset(email: String, completion: @escaping(Bool) -> Void) {
		self.auth.sendPasswordReset(withEmail: email) { (error) in
			if let error = error {
				print("\(error)")
			}
			
			completion(error != nil)
        }
    }
	
	/// Sends a code to update a password
	func updatePassword(oldPassword: String, newPassword: String, completion: @escaping(Bool) -> Void) {
		self.reauthenticate(oldPassword: oldPassword) { (success) in
			if success {
				self.auth.currentUser!.updatePassword(to: newPassword) { (error) in
				if let error = error {
					print("\(error)")
				}
				
				completion(error != nil)
				}
			} else {
				completion(false)
			}
		}
	}
	
	/// Sends a code to update a password
	func updatePhoneNumber(newNumber: String, completion: @escaping(Bool) -> Void) {
		if self.isSignedIn {
			let userDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier)
			
			userDocument.updateData(["phoneNumber" : newNumber]) { (error) in
				if let error = error {
					print("\(error)")
				}
				
				completion(error != nil)
			}
		} else {
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
			if self.isVerified {
				timer.invalidate()
				completion(true)
			}
		}.fire()
	}
	
	// MARK: Firestore Variables
	private let data = Firestore.firestore()
	
	// MARK: Firestore Methods
	func updateDetails() {
		self.getStoreInfo { (storeInformation) in
			self.storeDetails = storeInformation
		}
	}
	
	/// Stores user's details
	func uploadStoreDetails(name: String, email: String, phoneNumber: String, completion: @escaping(Bool) -> Void) {
		let userDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier)
		
		userDocument.setData(["storeName": name, "email": email, "phoneNumber": phoneNumber, "receipts": [], "newReceipts": []]) { (error) in
			if let error = error {
				print("\(error)")
			}
			
			completion(error != nil)
		}
	}
	
	// Gets store information
	private func getStoreInfo(completion: @escaping(Store) -> Void) {
		if self.isSignedIn {
			let storeDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier)
			
			storeDocument.getDocument { (document, error) in
				if let error = error {
					print("\(error)")
					return
				} else if let document = document {
					let storeName: String = document.get("storeName") as! String
					let email: String = self.auth.currentUser!.email!
					let phoneNumber: String = document.get("phoneNumber") as! String
					
					self.retrieveLogo { (logo) in
						completion(Store(name: storeName, email: email, phoneNumber: phoneNumber, logo: logo))
					}
				}
			}
		} else {
			completion(Store(name: "", email: "", phoneNumber: "", logo: nil))
		}
	}
	
	func checkUserExists(for code: String, completion: @escaping(Bool) -> Void) {
		completion(true)
	}
	
	func uploadLogo(storeLogo: UIImage, completion: @escaping(Bool) -> Void) {
		guard let image = storeLogo.pngData() else { completion(false); return }
		
		let imageStorage = self.storage.reference(withPath: "Store_Logos").child("\(self.uniqueIdentifier).png")
		let imageMetadata = StorageMetadata()
		imageMetadata.contentType = "image/png"
		
		imageStorage.putData(image, metadata: imageMetadata) { (metadata, error) in
			if let error = error {
				print("\(error)")
				completion(false)
			} else {
				self.storeDetails.addLogo(storeLogo)
				completion(true)
			}
		}
	}
	
	func retrieveLogo(completion: @escaping(UIImage) -> Void) {
		let imageStorage = self.storage.reference(withPath: "Store_Logos").child("\(self.uniqueIdentifier).png")
		
		imageStorage.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
			if let error = error {
				print(error.localizedDescription)
				completion(UIImage())
			} else {
				if let data = data {
					completion(UIImage(data: data)!)
				} else {
					completion(UIImage())
				}
			}
		}
	}
	
	func updateStoreName(newName: String, completion: @escaping(Bool) -> Void) {
		let userDocument: DocumentReference = data.collection("Stores").document(Authentication.account.uniqueIdentifier)
		
		userDocument.updateData(["storeName" : newName]) { (error) in
		if let error = error {
			print("\(error)")
		}
		
		completion(error != nil)
		}
	}
	
}
