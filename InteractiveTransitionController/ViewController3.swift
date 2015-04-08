//
//  ViewController3.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/3/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

// MARK: - Class definition

class ViewController3: UIViewController {
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    transitioningDelegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    InteractiveTransitionController.sharedController().view = view
    InteractiveTransitionController.sharedController().delegate = self
    InteractiveTransitionController.sharedController().direction = .Left
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.All.rawValue)
  }
}

// MARK: - InteractiveTransitionControllerDelegate extension

extension ViewController3: InteractiveTransitionControllerDelegate {
  
  func interactiveTransitionControllerStartLeftTransition() {
    dismissViewControllerAnimated(true, completion: { () -> Void in
    })
  }
}

// MARK: - UIViewControllerTransitioningDelegate extension

extension ViewController3: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ZoomAnimationController()
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ZoomAnimationController(unwind: true)
  }
  
  func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return InteractiveTransitionController.sharedController().newInteractiveTransitionObject()
  }
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return InteractiveTransitionController.sharedController().newInteractiveTransitionObject()
  }
}
