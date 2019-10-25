//
//  Gradient Background.swift
//  Receipts Store
//
//  Created by George Nick Gorzynski on 02/06/2018.
//  Copyright © 2018 g30r93g. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientBackground: UIView {
    
    var gradientLayer = CAGradientLayer()
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        // Colors
        gradientLayer.frame = self.layer.bounds
        gradientLayer.colors = [firstColor, secondColor].map{$0.cgColor}
        
        // Horizontal + Vertical
        if isHorizontal == true {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
