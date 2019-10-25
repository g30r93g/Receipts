//
//  Storage.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 25/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ImageStorage {
	
	// MARK: Initialisers
	init(storeID: String) {
		self.storeID = storeID
	}
	
	// MARK: Firebase Variables
	var storage = Storage()
	
	// MARK: Variables
	var storeID: String
	
	// MARK: Methods
	func retrieveStoreImage(completion: @escaping(UIImage?) -> Void) {
		completion(nil)
	}
	
	// MARK: Enums
	
}
