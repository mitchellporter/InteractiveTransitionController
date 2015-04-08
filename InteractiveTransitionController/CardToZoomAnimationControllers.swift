//
//  Delegates.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/2/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

class CardToZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  var duration: NSTimeInterval = 0.35
  var containerBackgroundColor: UIColor = UIColor.darkGrayColor()
  var minScale: CGFloat = 0.6
  
  private let unwind: Bool
  
  init(unwind newUnwind: Bool = false) {
    unwind = newUnwind
    super.init()
  }
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    transitionContext.containerView().backgroundColor = containerBackgroundColor
    
    let fromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    let fromFrame: CGRect = fromView.frame
    
    if unwind == false {
      // Move the From View's anchor point to the bottom left.
      fromView.layer.anchorPoint = CGPoint(x: 0, y: 1)
      fromView.frame = fromFrame
      
      // Scale down the To View
      transitionContext.containerView().insertSubview(toView, belowSubview: fromView)
      
      // Reset the view in case it was previously transformed
      toView.transform = CGAffineTransformIdentity
      toView.frame = fromFrame
      
      // Give the To View its initial scale.
      toView.transform = CGAffineTransformMakeScale(minScale, minScale)
      
    } else {
      transitionContext.containerView().addSubview(toView)
      
      // Move the To View's anchor point to the bottom left.
      toView.transform = CGAffineTransformIdentity
      toView.layer.anchorPoint = CGPoint(x: 0, y: 1)
      toView.frame = fromFrame
      
      // Move the To View to the left and rotate it
      toView.frame = CGRectOffset(fromFrame, -fromFrame.size.width * 0.8, fromFrame.size.height * 0.3)
      toView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_4))
    }
    
    UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
      if self.unwind == false {
        // Move the From View to the left and rotate it
        fromView.frame = CGRectOffset(fromFrame, -fromFrame.size.width * 0.8, fromFrame.size.height * 0.3)
        fromView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_4))
        
        // Scale the To View back up
        toView.transform = CGAffineTransformIdentity
        
      } else {
        // Scale down the From View
        fromView.transform = CGAffineTransformMakeScale(self.minScale, self.minScale)
        
        // Bring the To View to the front. This will rotate it and move it right.
        toView.transform = CGAffineTransformIdentity
        toView.frame = fromFrame
      }
      
      }) { (complete: Bool) -> Void in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
  }
  
  func animationEnded(transitionCompleted: Bool) {
  }
}
