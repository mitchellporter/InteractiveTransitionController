//
//  UIComponents.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/2/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

@IBDesignable
class Panel: UIView {
  
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
  
  @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
    didSet {
      layer.borderColor = borderColor.CGColor
    }
  }
}

class NavigationDirectionArrow: UIView {
  
  @IBInspectable var pointRight: Bool = true {
    didSet {
      if oldValue == pointRight {
        return
      }
      setNeedsLayout()
    }
  }
  
  var lineWidth: CGFloat = 5.0 {
    didSet {
      if oldValue == lineWidth {
        return
      }
      let shapeLayer: CAShapeLayer = layer as CAShapeLayer
      shapeLayer.lineWidth = lineWidth
    }
  }
  
  var strokeColor: UIColor = UIColor.whiteColor() {
    didSet {
      if CGColorEqualToColor(oldValue.CGColor, strokeColor.CGColor) {
        return
      }
      let shapeLayer: CAShapeLayer = layer as CAShapeLayer
      shapeLayer.strokeColor = strokeColor.CGColor
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    backgroundColor = UIColor.clearColor()
    alpha = 0.7
    
    let shapeLayer: CAShapeLayer = layer as CAShapeLayer
    shapeLayer.lineWidth = lineWidth
    shapeLayer.strokeColor = strokeColor.CGColor
    shapeLayer.lineCap = kCALineCapRound
    shapeLayer.lineJoin = kCALineJoinRound
  }
  
  override class func layerClass() -> AnyClass {
    return CAShapeLayer.self
  }
  
  override func layoutSubviews() {
    let shapeLayer: CAShapeLayer = layer as CAShapeLayer
    let width = bounds.size.width
    let height = bounds.size.height
    var path: UIBezierPath = UIBezierPath()
    if pointRight == true {
      path.moveToPoint(CGPoint(x: lineWidth / 2, y: lineWidth / 2))
      path.addLineToPoint(CGPoint(x: width - lineWidth / 2, y: height / 2))
      path.addLineToPoint(CGPoint(x: lineWidth / 2, y: height - lineWidth / 2))
      path.addLineToPoint(CGPoint(x: width - lineWidth / 2, y: height / 2))
    } else {
      path.moveToPoint(CGPoint(x: width - lineWidth / 2, y: lineWidth / 2))
      path.addLineToPoint(CGPoint(x: lineWidth / 2, y: height / 2))
      path.addLineToPoint(CGPoint(x: width - lineWidth / 2, y: height - lineWidth / 2))
      path.addLineToPoint(CGPoint(x: lineWidth / 2, y: height / 2))
    }
    shapeLayer.path = path.CGPath
  }
}
