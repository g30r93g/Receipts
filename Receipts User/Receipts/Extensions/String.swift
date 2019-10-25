//
//  String.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 21/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation

extension String {
	
	func addSpace(at: Int) -> String {
		var newString = ""
		
		for (index, char) in self.enumerated() {
			newString += String(char)
			
			if index == at {
				newString += " "
			}
		}
		
		return newString
	}
	
	func addCountryCode(_ code: String, at: Int) -> String {
		var newString = ""
		
		for (index, char) in self.enumerated() {
			if index == at {
				newString += code
				continue
			}
			
			newString += String(char)
		}
		
		return newString
	}
	
}
