//
//  Round.swift
//  Interchange
//
//  Created by George Nick Gorzynski on 20/08/2018.
//  Copyright © 2018 g30r93g. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView: UIView {
	
	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
	
	@IBInspectable var borderColor: UIColor = .clear {
		didSet {
			layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable var borderWidth: CGFloat = 0.0 {
		didSet {
			layer.borderWidth = borderWidth
		}
	}
	
}

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
	
	@IBInspectable var imageAngle: CGFloat = 0.0 {
		didSet {
			self.imageView?.transform = CGAffineTransform(rotationAngle: (imageAngle * .pi/180))
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
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
	
	@IBInspectable var glow: Bool = false {
		didSet {
			toggleGlow()
		}
	}
	
	private func toggleGlow() {
		if self.glow == true {
			self.layer.shadowColor = UIColor.white.cgColor
			self.layer.shadowRadius = 5
			self.layer.shadowOpacity = 0.4
		} else {
			self.layer.shadowOpacity = 0
		}
	}
    
}

@IBDesignable
class RoundLabel: UILabel {
	
	var padding: UIEdgeInsets {
		return UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
	}
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
	
	@IBInspectable var labelAngle: CGFloat = 0.0 {
		didSet {
			self.transform = CGAffineTransform(rotationAngle: (labelAngle * .pi/180))
		}
	}
	
	@IBInspectable var leftPadding: CGFloat = 4.0 {
		didSet {
			applyPadding()
		}
	}
	
	@IBInspectable var topPadding: CGFloat = 4.0 {
		didSet {
			applyPadding()
		}
	}
	
	@IBInspectable var rightPadding: CGFloat = 4.0 {
		didSet {
			applyPadding()
		}
	}
	
	@IBInspectable var bottomPadding: CGFloat = 4.0 {
		didSet {
			applyPadding()
		}
	}
	
	func applyPadding() {
		self.frame.inset(by: self.padding)
	}
	
}

@IBDesignable
class RoundUITableViewCell: UITableViewCell {
	
	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
	
}

@IBDesignable
class RoundUICollectionViewCell: UICollectionViewCell {
	
	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
	
}
