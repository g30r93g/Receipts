//
//  AccountViewController.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 19/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var userImage: RoundImageView!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var userEmail: UILabel!
	@IBOutlet weak var userPhoneNumber: UILabel!
	@IBOutlet weak var authenticateOnLaunchToggle: UISwitch!
	@IBOutlet weak var pushNotificationToggle: UISwitch!
	@IBOutlet weak var emailNotificationToggle: UISwitch!
	
	// MARK: View Controller Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.loadUserDetails()
		self.loadUserDefaults()
	}
	
	// MARK: Methods
	private func loadUserDetails() {
		Authentication.account.getUserInfo(type: .name) { (name) in
			self.userName.text = name
		}
		
		Authentication.account.getUserInfo(type: .email) { (email) in
			self.userEmail.text = email
		}
		
		Authentication.account.getUserInfo(type: .phoneNumber) { (number) in
			self.userPhoneNumber.text = number.addSpace(at: 4).addCountryCode("+44 ", at: 0)
		}
	}
	
	private func loadUserDefaults() {
		let authenticateOnLaunch = UserDefaults.standard.bool(forKey: "Authenticate On Launch")
		let pushNotification = UserDefaults.standard.bool(forKey: "Push Notifications")
		let emailNotification = UserDefaults.standard.bool(forKey: "Email Notifications")
		
		self.authenticateOnLaunchToggle.setOn(authenticateOnLaunch, animated: true)
		self.pushNotificationToggle.setOn(pushNotification, animated: true)
		self.emailNotificationToggle.setOn(emailNotification, animated: true)
	}
	
	private func updatePrefs() {
		Authentication.account.updateUserPrefs(prefs: ["pushNotifs" : self.pushNotificationToggle.isOn, "emailNotifs" : self.emailNotificationToggle.isOn]) { (success) in
			if success {
				print("Updated")
			} else {
				fatalError()
			}
		}
	}
	
	private func showConfirmationAlert(text: String) {
		let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	// MARK: IBActions
	@IBAction func authenticateOnLaunchToggled(_ sender: UISwitch) {
		UserDefaults.standard.set(sender.isOn, forKey: "Authenticate On Launch")
	}
	
	@IBAction func pushNotificationToggled(_ sender: UISwitch) {
		UserDefaults.standard.set(sender.isOn, forKey: "Push Notifications")
		
		self.updatePrefs()
	}
	
	@IBAction func emailNotificationToggled(_ sender: UISwitch) {
		UserDefaults.standard.set(sender.isOn, forKey: "Email Notifications")
		
		self.updatePrefs()
	}

}

extension AccountViewController {
	
	// MARK: Table View Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 1:
				// Change Password
				let alert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
				
				alert.addTextField { (textField) in
					textField.isSecureTextEntry = true
					textField.keyboardAppearance = .dark
					textField.textContentType = .newPassword
					textField.placeholder = "Old Password"
					textField.returnKeyType = .continue
				}
				
				alert.addTextField { (textField) in
					textField.isSecureTextEntry = true
					textField.keyboardAppearance = .dark
					textField.textContentType = .newPassword
					textField.placeholder = "New Password"
					textField.returnKeyType = .continue
				}
				
				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
					guard let oldPassword = alert.textFields![0].text else { return }
					guard let newPassword = alert.textFields![1].text else { return }
					
					Authentication.account.updatePassword(oldPassword: oldPassword, newPassword: newPassword) { (success) in
						if success {
							self.showConfirmationAlert(text: "Password updated!")
						} else {
							fatalError()
						}
					}
				}))
				
				self.present(alert, animated: true, completion: nil)
			case 2:
				// Update Phone Number
				let alert = UIAlertController(title: "Update Phone Number", message: nil, preferredStyle: .alert)
				
				alert.addTextField { (textField) in
					textField.keyboardType = .phonePad
					textField.keyboardAppearance = .dark
					textField.textContentType = .telephoneNumber
					textField.placeholder = "Phone Number"
					textField.returnKeyType = .continue
				}
				
				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
					guard let newPhoneNumber = alert.textFields![0].text else { return }
					
					Authentication.account.updatePhoneNumber(newNumber: newPhoneNumber) { (success) in
						if success {
							self.showConfirmationAlert(text: "Phone number updated!")
						} else {
							fatalError()
						}
					}
				}))
				
				self.present(alert, animated: true, completion: nil)
			default:
				break
			}
		case 1:
			switch indexPath.row {
			case 0:
				self.authenticateOnLaunchToggle.setOn(!self.authenticateOnLaunchToggle.isOn, animated: true)
			case 1:
				self.pushNotificationToggle.setOn(!self.pushNotificationToggle.isOn, animated: true)
			case 2:
				self.emailNotificationToggle.setOn(!self.emailNotificationToggle.isOn, animated: true)
			default:
				break
			}
		case 2:
			switch indexPath.row {
			case 0:
				// Privacy Policy
				let alert = UIAlertController(title: "Privacy Policy\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
				
				// Add Privacy Policy as a scrollable text label
				let text = UITextView(frame: CGRect(x: 8.0, y: 50.0, width: 260, height: 250.0))
				
				text.allowsEditingTextAttributes = false
				text.isEditable = false
				text.isSelectable = false
				text.clipsToBounds = true
				text.showsVerticalScrollIndicator = false
				text.showsHorizontalScrollIndicator = false
				text.backgroundColor = UIColor.white.withAlphaComponent(0)
				text.text = """
				This privacy policy has been written to provide you (the user) with an understanding of how we use your data in this application. When you choose to opt in to services or provide personal details, we collect and use it to provide you with features and services. We do not sell any of your personal data or any collected data. To be able to provide you with certain features, we may have to share data with third parties for the following reasons:
				• Parties involved with providing services that you’ve opted into using
				• Law enforcement where applicable
				
				INSERT POLICY HERE
				
				How to contact us:
				The data controller responsible for your personal information for the purposes of the applicable European Union data protection law is:
				
				• George Nick Gorzynski
				• Email: georgegorzynski@me.com
				
				If you have any queries about this Privacy Policy or how we collect your data, please feel free to contact us on the above methods.
				"""
				
				alert.view.addSubview(text)
				alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
				
				present(alert, animated: true, completion: nil)
			case 1:
				// Terms and Conditions
				let alert = UIAlertController(title: "Terms & Conditions\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
				
				// Add Privacy Policy as a scrollable text label
				let text = UITextView(frame: CGRect(x: 8.0, y: 50.0, width: 260, height: 250.0))
				
				text.allowsEditingTextAttributes = false
				text.isEditable = false
				text.isSelectable = false
				text.clipsToBounds = true
				text.showsVerticalScrollIndicator = false
				text.showsHorizontalScrollIndicator = false
				text.backgroundColor = UIColor.white.withAlphaComponent(0)
				text.text = """
				Insert Terms & Conditions Here
				"""
				
				alert.view.addSubview(text)
				alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
				
				present(alert, animated: true, completion: nil)
			case 2:
				Authentication.account.signOut { (success) in
					if success {
						self.performSegue(withIdentifier: "Sign Out", sender: self)
						UserDefaults.standard.set(false, forKey: "Authenticate On Launch")
					}
				}
			default:
				break
			}
		default:
			break
		}
	}
	
}
