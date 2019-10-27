//
//  AddLogoViewController.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 23/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit

class AddLogoViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var logo: RoundImageView!
	@IBOutlet weak var upload: RoundButton!
	@IBOutlet weak var uploadIndicator: UIActivityIndicatorView!
	
	// MARK: Variables
	let imagePickerController = UIImagePickerController()

	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.imagePickerController.delegate = self
		
		self.upload.setTitle("Select", for: .normal)
    }
	
	// MARK: Methods
	private func startLoading() {
		self.uploadIndicator.startAnimating()
	}
	
	private func stopLoading() {
		self.uploadIndicator.stopAnimating()
	}
	
	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "Complete Sign Up" {
			Authentication.account.uploadLogo(storeLogo: self.logo.image!) { (success) in
				if success {
//					segue.perform()
				} else {
					fatalError("Couldn't upload logo.")
				}
			}
		}
	}
	
	// MARK: IBActions
	@IBAction func uploadTapped(_ sender: RoundButton) {
		if self.logo.image == nil {
			self.selectImage()
		} else {
			self.performSegue(withIdentifier: "Complete Sign Up", sender: nil)
		}
	}
}

extension AddLogoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: Image Selection Methods
	private func selectImage() {
		self.imagePickerController.allowsEditing = true
		self.imagePickerController.sourceType = .photoLibrary
		
		self.present(self.imagePickerController, animated: true, completion: nil)
	}
	
	// MARK: Delegate Methods
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			self.logo.contentMode = .scaleAspectFit
            self.logo.image = pickedImage
			
			self.upload.setTitle("Upload", for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
}
