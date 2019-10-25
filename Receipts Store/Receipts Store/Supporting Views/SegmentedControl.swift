//
//  SegmentedControl.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 20/08/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SegmentedControl: UIControl {
	
	fileprivate var labels = [UILabel]()
	var thumbView = UIView()
	
	var items: [String] = ["Week", "Month", "Year"] {
		didSet {
			setupLabels()
		}
	}
	
	var selectedIndex : Int = 0 {
		didSet {
			displayNewSelectedIndex()
		}
	}
	
	@IBInspectable var selectedLabelColor : UIColor = UIColor.black {
		didSet {
			setSelectedColors()
		}
	}
	
	@IBInspectable var unselectedLabelColor : UIColor = UIColor.white {
		didSet {
			setSelectedColors()
		}
	}
	
	@IBInspectable var thumbColor : UIColor = UIColor.white {
		didSet {
			setSelectedColors()
		}
	}
	
	@IBInspectable var borderColor : UIColor = UIColor.white {
		didSet {
			layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 20, weight: .medium) {
		didSet {
			setFont()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		setupView()
	}
	
	func setupView() {
		self.layer.cornerRadius = 10
		self.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
		self.layer.borderWidth = 2
		
		backgroundColor = UIColor.clear
		
		setupLabels()
		
		addIndividualItemConstraints(labels, mainView: self, padding: 0)
		
		insertSubview(thumbView, at: 0)
	}
	
	func setupLabels(){
		
		for label in labels {
			label.removeFromSuperview()
		}
		
		labels.removeAll(keepingCapacity: true)
		
		for index in 1...items.count {
			
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
			label.text = items[index - 1]
			label.backgroundColor = UIColor.clear
			label.textAlignment = .center
			label.font = self.font
			label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
			label.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(label)
			labels.append(label)
		}
		
		addIndividualItemConstraints(labels, mainView: self, padding: 0)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		var selectFrame = self.bounds
		let newWidth = selectFrame.width / CGFloat(items.count)
		selectFrame.size.width = newWidth
		thumbView.frame = selectFrame
		thumbView.backgroundColor = thumbColor
		thumbView.layer.cornerRadius = 10
		
		displayNewSelectedIndex()
		
	}
	
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		
		let location = touch.location(in: self)
		
		var calculatedIndex : Int?
		for (index, item) in labels.enumerated() {
			if item.frame.contains(location) {
				calculatedIndex = index
			}
		}
		
		
		if calculatedIndex != nil {
			selectedIndex = calculatedIndex!
			sendActions(for: .valueChanged)
		}
		
		return false
	}
	
	func displayNewSelectedIndex(){
		for item in labels {
			item.textColor = unselectedLabelColor
		}
		
		let label = labels[selectedIndex]
		label.textColor = selectedLabelColor
		
		UIView.animate(withDuration: 0.1) {
			self.thumbView.frame = label.frame
		}
		
	}
	
	func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, padding: CGFloat) {
		
		_ = mainView.constraints
		
		for (index, button) in items.enumerated() {
			
			let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0)
			
			let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0)
			
			var rightConstraint : NSLayoutConstraint!
			
			if index == items.count - 1 {
				
				rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -padding)
				
			}else{
				
				let nextButton = items[index+1]
				rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -padding)
			}
			
			
			var leftConstraint : NSLayoutConstraint!
			
			if index == 0 {
				
				leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: padding)
				
			}else{
				
				let prevButton = items[index-1]
				leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevButton, attribute: .right, multiplier: 1.0, constant: padding)
				
				let firstItem = items[0]
				
				let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
				
				mainView.addConstraint(widthConstraint)
			}
			
			mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
		}
	}
	
	func setSelectedColors(){
		for item in labels {
			item.textColor = unselectedLabelColor
		}
		
		if labels.count > 0 {
			labels[0].textColor = selectedLabelColor
		}
		
		thumbView.backgroundColor = thumbColor
	}
	
	func setFont(){
		for item in labels {
			item.font = font
		}
	}
	
}

//@IBDesignable
//class SegmentedControl: UIControl {
//
//	// MARK: IBInspectables
//	@IBInspectable var borderColor: UIColor = .clear {
//		didSet {
//			self.layer.borderColor = self.borderColor.cgColor
//		}
//	}
//
//	@IBInspectable var borderWidth: CGFloat = 1.5 {
//		didSet {
//			self.layer.borderWidth = self.borderWidth
//		}
//	}
//
//	@IBInspectable var selectorColor: UIColor = .clear {
//		didSet {
//			self.setColours()
//		}
//	}
//
//	@IBInspectable var selectedTextColor: UIColor = .black {
//		didSet {
//			self.setColours()
//		}
//	}
//
//	@IBInspectable var unselectedTextColor: UIColor = .white {
//		didSet {
//			self.setColours()
//		}
//	}
//
//	@IBInspectable var numberOfItems: Int = 2 {
//		didSet {
//			self.displayNewSelectedIndex()
//		}
//	}
//
//	@IBInspectable var selectedIndex: Int = 0 {
//		didSet {
//			self.displayNewSelectedIndex()
//		}
//	}
//
//	// MARK: Variables
//	private var items: [String] = ["Week", "Month", "Year"] {
//		didSet {
//			self.setupLabels()
//		}
//	}
//	private var labels: [UILabel] = []
//	private var selectedView = UIView()
//
//	// MARK: Inits
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//
//		self.setupView()
//	}
//
//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
//
//		self.setupView()
//	}
//
//	// MARK: Overrides
//	override func layoutSubviews() {
//		super.layoutSubviews()
//
//		var selectFrame = self.bounds
//		let newWidth = selectFrame.width / CGFloat(self.items.count)
//		selectFrame.size.width = newWidth
//
//		selectedView.frame = selectFrame
//		selectedView.backgroundColor = selectorColor
//		selectedView.layer.cornerRadius = selectedView.frame.height / 2
//
//		self.displayNewSelectedIndex()
//	}
//
//	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//		super.beginTracking(touch, with: event)
//
//		let location = touch.location(in: self)
//
//		var calculatedIndex: Int?
//		for (index, label) in self.labels.enumerated() {
//			if label.frame.contains(location) {
//				calculatedIndex = index
//			}
//		}
//
//		if calculatedIndex != nil {
//			self.selectedIndex = calculatedIndex!
//			self.sendActions(for: .valueChanged)
//		}
//
//		return false
//	}
//
//	// MARK: Methods
//	func setupView() {
//		self.layer.cornerRadius = self.frame.height / 2
//		self.backgroundColor = UIColor(named: "Text Field")!
//
//		self.setupLabels()
//
//		self.addIndividualItemConstraints(labels, mainView: self, padding: 0)
//		self.insertSubview(selectedView, at: 0)
//	}
//
//	func setupLabels() {
//		for label in self.labels {
//			label.removeFromSuperview()
//		}
//
//		labels.removeAll(keepingCapacity: true)
//
//		for (index, text) in self.items.enumerated() {
//			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: self.frame.height))
//
//			label.text = text
//			label.textAlignment = .center
//			label.backgroundColor = UIColor(named: "Text Field")!
//			label.textColor = (index == selectedIndex) ? selectedTextColor : unselectedTextColor
//			label.translatesAutoresizingMaskIntoConstraints	= false
//
//			self.addSubview(label)
//			self.labels.append(label)
//		}
//
//		self.addIndividualItemConstraints(labels, mainView: self, padding: 0)
//	}
//
//	func addIndividualItemConstraints(_ items: [UILabel], mainView: UIView, padding: CGFloat) {
//		_ = mainView.constraints
//
//		for (index, text) in items.enumerated() {
//			let topConstraint = NSLayoutConstraint(item: text, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0)
//
//			let bottomConstraint = NSLayoutConstraint(item: text, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0)
//
//			var rightConstraint: NSLayoutConstraint {
//				if index == self.items.count - 1 {
//					return NSLayoutConstraint(item: text, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -padding)
//				} else {
//					return NSLayoutConstraint(item: text, attribute: .right, relatedBy: .equal, toItem: self.items[index+1], attribute: .left, multiplier: 1.0, constant: -padding)
//				}
//			}
//
//			var leftConstraint: NSLayoutConstraint {
//				if index == 0 {
//					return NSLayoutConstraint(item: text, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: padding)
//				} else {
//					mainView.addConstraint(NSLayoutConstraint(item: text, attribute: .width, relatedBy: .equal, toItem: self.items[0], attribute: .width, multiplier: 1.0, constant: 0))
//
//					return NSLayoutConstraint(item: text, attribute: .left, relatedBy: .equal, toItem: self.items[index-1], attribute: .right, multiplier: 1.0, constant: padding)
//				}
//			}
//
//			mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
//		}
//	}
//
//	func displayNewSelectedIndex() {
//		for label in self.labels {
//			label.textColor = self.unselectedTextColor
//		}
//
//		let label = labels[selectedIndex]
//		label.textColor = self.selectedTextColor
//
//		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, animations: {
//			self.selectedView.frame = label.frame
//		})
//	}
//
//	// MARK: Private Methods
//	private func setColours() {
//		for label in self.labels {
//			label.textColor = self.unselectedTextColor
//		}
//
//		self.labels[selectedIndex].textColor = self.selectedTextColor
//		self.selectedView.backgroundColor = self.selectorColor
//	}
//
//}
