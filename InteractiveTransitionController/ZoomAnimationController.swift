//
//  ZoomAnimationControllers.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/3/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

class ZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
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
    var fromFrame: CGRect = fromView.frame
    
    let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    transitionContext.containerView().insertSubview(toView, belowSubview: fromView)
    
    // The offset between the views as they transition.
    var offset: CGFloat = fromView.frame.size.width - 55
    if unwind == true {
      offset = -offset
    }
    
    // Reset the To View in case it was previously transformed.
    toView.transform = CGAffineTransformIdentity
    toView.frame = fromFrame
    
    // Give the To View its initial scale and position.
    toView.transform = CGAffineTransformMakeScale(minScale, minScale)
    toView.frame = CGRectOffset(toView.frame, offset, 0)
    
    UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
      
      // Move the From View to the left and scale it down.
      fromView.transform = CGAffineTransformMakeScale(self.minScale, self.minScale)
      fromView.frame = CGRectOffset(fromView.frame, -offset, 0)
      
      // Move the To View to the left and scale it up.
      toView.transform = CGAffineTransformIdentity
      toView.frame = CGRectOffset(toView.frame, -offset, 0)
      
      }) { (complete: Bool) -> Void in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
  }
  
  func animationEnded(transitionCompleted: Bool) {
  }
}
