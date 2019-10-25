//
//  Text Field.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 11/07/2018.
//  Copyright © 2018 g30r93g. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ImageTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateImageView()
        }
    }
    @IBInspectable var leftImageColor: UIColor = .clear {
        didSet {
            updateImageView()
        }
    }
    
    @IBInspectable var placeholderTextColor: UIColor = UIColor.clear {
        didSet {
            updatePlaceholderTextColor()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 5)
    }
    
    func updateImageView() {
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = leftImageColor
            imageView.contentMode = .scaleAspectFit
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = .never
        }
    }
    
    func updatePlaceholderTextColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor : placeholderTextColor])
    }
    
}
