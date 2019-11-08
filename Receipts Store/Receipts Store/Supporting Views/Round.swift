//
//  Round.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 05/06/2018.
//  Copyright © 2018 g30r93g. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
}

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
	@IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
	
}

@IBDesignable
class RoundImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
	
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
}

@IBDesignable
class RoundLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
	
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
	
}
