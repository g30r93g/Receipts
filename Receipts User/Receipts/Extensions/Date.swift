//
//  Date.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 19/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import FirebaseFirestore

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
	
	func time(style: DateFormatter.Style = .short) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = style
		dateFormatter.dateFormat = "HH:mm"
		dateFormatter.doesRelativeDateFormatting = false
		
		return dateFormatter.string(from: self)
	}
	
	func day(style: DateFormatter.Style = .medium) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = style
		dateFormatter.timeStyle = .none
		dateFormatter.doesRelativeDateFormatting = false
		
		return dateFormatter.string(from: self)
	}
	
}
