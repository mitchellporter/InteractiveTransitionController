//
//  ViewController.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/1/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

// MARK: - Class definition

class ViewController: UIViewController {

  let edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    InteractiveTransitionController.sharedController().view = view
    InteractiveTransitionController.sharedController().delegate = self
    InteractiveTransitionController.sharedController().direction = .Right
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.All.rawValue)
  }
}

// MARK: - InteractiveTransitionControllerDelegate extension

extension ViewController: InteractiveTransitionControllerDelegate {
  
  func interactiveTransitionControllerStartRightTransition() {
    performSegueWithIdentifier("CardToZoom", sender: self)
  }
}
