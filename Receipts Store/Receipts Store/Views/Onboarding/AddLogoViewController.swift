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
	
	// MARK: Variables
	let imagePickerController = UIImagePickerController()

	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(selectImage(recogniser:)))
		tapGestureRecogniser.numberOfTapsRequired = 1
		tapGestureRecogniser.numberOfTouchesRequired = 1
		self.logo.addGestureRecognizer(tapGestureRecogniser)
		
		self.imagePickerController.delegate = self
    }
	
	// MARK: IBActions
	@IBAction func continueTapped(_ sender: RoundButton) {
		
		self.performSegue(withIdentifier: "", sender: self)
	}

}

extension AddLogoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: Image Selection Methods
	@objc private func selectImage(recogniser: UIGestureRecognizer) {
		self.imagePickerController.allowsEditing = true
		self.imagePickerController.sourceType = .photoLibrary
		
		self.present(self.imagePickerController, animated: true, completion: nil)
	}
	
	// MARK: Delegate Methods
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			self.logo.contentMode = .scaleAspectFit
            self.logo.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
}
