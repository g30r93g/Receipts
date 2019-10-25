//
//  Date.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 19/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import Firebase

extension Date {
	
	func adding(seconds: Double) -> Date {
		return self.addingTimeInterval(seconds)
	}
	
	func daysAgo(_ days: Int) -> Date {
		let day = 86400 // Number of secs in one day
		return self.addingTimeInterval(TimeInterval(-day * days))
	}
	
	func convertToTimestamp() -> Timestamp {
		return Timestamp(date: self)
	}
	
	func time() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short
		dateFormatter.dateFormat = "HH:mm"
		dateFormatter.doesRelativeDateFormatting = false
		
		return dateFormatter.string(from: self)
	}
	
	func day() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.doesRelativeDateFormatting = false
		
		return dateFormatter.string(from: self)
	}
	
}
