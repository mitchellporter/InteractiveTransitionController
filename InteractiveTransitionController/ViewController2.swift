//
//  ViewController2.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/2/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

// MARK: - Class definition

class ViewController2: UIViewController {
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    transitioningDelegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    InteractiveTransitionController.sharedController().view = view
    InteractiveTransitionController.sharedController().delegate = self
    InteractiveTransitionController.sharedController().direction = .Both
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.All.rawValue)
  }
}

// MARK: - InteractiveTransitionControllerDelegate extension

extension ViewController2: InteractiveTransitionControllerDelegate {
  
  func interactiveTransitionControllerStartLeftTransition() {
    dismissViewControllerAnimated(true, completion: { () -> Void in
    })
  }
  
  func interactiveTransitionControllerStartRightTransition() {
    performSegueWithIdentifier("Zoom", sender: self)
  }
}

// MARK: - UIViewControllerTransitioningDelegate extension

extension ViewController2: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardToZoomAnimationController()
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardToZoomAnimationController(unwind: true)
  }
  
  func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return InteractiveTransitionController.sharedController().newInteractiveTransitionObject()
  }
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return InteractiveTransitionController.sharedController().newInteractiveTransitionObject()
  }
}