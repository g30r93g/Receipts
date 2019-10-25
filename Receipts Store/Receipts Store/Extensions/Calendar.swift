//
//  Calendar.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 20/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation

extension Calendar {
	
	func today() -> Date {
		return Date()
	}
	
	func previousDay(from: Date) -> Date {
		return self.date(byAdding: .day, value: -1, to: from)!
	}
	
}
