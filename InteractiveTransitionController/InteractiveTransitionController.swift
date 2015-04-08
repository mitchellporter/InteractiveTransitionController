//
//  InteractiveTransitionController.swift
//  InteractiveTransitions
//
//  Created by  Jose Villegas on 4/2/15.
//  Copyright (c) 2015  Jose Villegas. All rights reserved.
//

import UIKit

// MARK: - Direction enumeration

enum InteractiveTransitionControllerDirection {
  case Both
  case Right
  case Left
}

// MARK: - Delegate protocol

@objc protocol InteractiveTransitionControllerDelegate: NSObjectProtocol {
  optional func interactiveTransitionControllerStartRightTransition()
  optional func interactiveTransitionControllerStartLeftTransition()
}

// MARK: - Public methods

extension InteractiveTransitionController {
  
  class func sharedController() -> InteractiveTransitionController {
    struct Static {
      static var token: dispatch_once_t = 0
      static var sharedController: InteractiveTransitionController?
    }
    dispatch_once(&Static.token) {
      Static.sharedController = InteractiveTransitionController()
    }
    return Static.sharedController!
  }
  
  func newInteractiveTransitionObject() -> UIViewControllerInteractiveTransitioning {
    interactiveTransitionObject = UIPercentDrivenInteractiveTransition()
    return interactiveTransitionObject!
  }
  
  func reset() {
    delegate = nil
    interactiveTransitionObject = nil
    isTransitioning = false
    direction = .Both
    maxTranslation = 0
    initialTranslation = 0
    lastTranslation = 0
    priorToLastTranslation = 0
  }
}

// MARK: - Class definition

class InteractiveTransitionController: NSObject {
  
  // MARK: - Public stored properties
  
  weak var delegate: InteractiveTransitionControllerDelegate? {
    didSet {
      if delegate === oldValue {
        return
      }
      if delegate == nil {
        // Disable the gesture recognizers when the delegate is removed.
        leftEdgeGestureRecognizer.enabled = false
        rightEdgeGestureRecognizer.enabled = false
      } else {
        setupGestureRecognizers()
      }
    }
  }
  
  weak var view: UIView? {
    didSet {
      if view === oldValue {
        return
      }
      NSNotificationCenter.defaultCenter().removeObserver(self)
      if let view = oldValue {
        view.removeGestureRecognizer(leftEdgeGestureRecognizer)
        view.removeGestureRecognizer(rightEdgeGestureRecognizer)
      }
      if let view = view {
        view.addGestureRecognizer(leftEdgeGestureRecognizer)
        view.addGestureRecognizer(rightEdgeGestureRecognizer)
        adjustToCurrentOrientation()
        
        if view is UIWindow {
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
        }
      }
    }
  }
  
  var direction: InteractiveTransitionControllerDirection = .Both {
    didSet {
      if direction == oldValue {
        return
      }
      // Do not enable the gesture recognizers if there is no delegate.
      if delegate != nil {
        setupGestureRecognizers()
      }
    }
  }
  
  // MARK: - Private properties
  
  private var interactiveTransitionObject: UIPercentDrivenInteractiveTransition?
  private var isTransitioning = false
  private var maxTranslation: CGFloat = 0
  private var initialTranslation: CGFloat = 0
  private var lastTranslation: CGFloat = 0
  private var priorToLastTranslation: CGFloat = 0
  private let leftEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
  private let rightEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
  
  // MARK: - Overriden methods
  
  override init() {
    super.init()
    leftEdgeGestureRecognizer.addTarget(self, action: "didLeftEdgePan:")
    rightEdgeGestureRecognizer.addTarget(self, action: "didRightEdgePan:")
  }
  
  // MARK: - Gesture recognizer actions
  
  func didLeftEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
    pan(sender.state, right: false)
  }
  
  func didRightEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
    pan(sender.state, right: true)
  }
  
  // MARK: - Observer methods
  
  func orientationDidChange(notification: NSNotification) {
    adjustToCurrentOrientation()
  }
  
  // MARK: - Private methods
  
  private func setupGestureRecognizers() {
    switch direction {
    case .Both:
      leftEdgeGestureRecognizer.enabled = true
      rightEdgeGestureRecognizer.enabled = true
    case .Right:
      leftEdgeGestureRecognizer.enabled = false
      rightEdgeGestureRecognizer.enabled = true
    case .Left:
      leftEdgeGestureRecognizer.enabled = true
      rightEdgeGestureRecognizer.enabled = false
    }
  }
  
  private func pan(state: UIGestureRecognizerState, right: Bool) {
    if let view = view {
      
      var translation: CGFloat = 0
      var location: CGFloat = 0
      if right {
        translation = -rightEdgeGestureRecognizer.translationInView(view).x
        location = rightEdgeGestureRecognizer.locationInView(view).x
      } else {
        translation = leftEdgeGestureRecognizer.translationInView(view).x
        location = leftEdgeGestureRecognizer.locationInView(view).x
      }
      
      switch state {
      case .Began:
        isTransitioning = true
        
        // Check to see that the manager is properly set up.
        // A delegate must be set and the delegate must implement the appropriate method.
        // The delegate is responsible for starting the transition.
        var isValid = true
        if let delegate = delegate {
          if right {
            if false == delegate.respondsToSelector("interactiveTransitionControllerStartRightTransition") {
              isValid = false
            }
          } else {
            if false == delegate.respondsToSelector("interactiveTransitionControllerStartLeftTransition") {
              isValid = false
            }
          }
        } else {
          // There is no delegate.
          isValid = false
        }
        if isValid == false {
          // Cancel the current gesture recognizer.
          if (right) {
            rightEdgeGestureRecognizer.enabled = false
            rightEdgeGestureRecognizer.enabled = true
          } else {
            leftEdgeGestureRecognizer.enabled = false
            leftEdgeGestureRecognizer.enabled = true
          }
          reset()
          return
        }
        
        // There is usually a small translation at the beginning.
        // We want to take it into account so that a 0% value is at the point where the gesture began.
        initialTranslation = translation
        
        // The width of the screen is used to determine the percentage value.
        // Subtract a small amount so that a 100% value is not at the edge of the screen.
        let margin: CGFloat = 50
        if (right) {
          maxTranslation = location - margin
        } else {
          maxTranslation = view.frame.size.width - location - margin
        }
        
        // The interactiveTransitionObject will not be available until after the delegate method is called.
        // The delegate should start the transition and a transition object will become available when
        // the presented controller requests the object from this controller.
        if let delegate = delegate {
          if right {
            delegate.interactiveTransitionControllerStartRightTransition!()
          } else {
            delegate.interactiveTransitionControllerStartLeftTransition!()
          }
        }
        
      case .Changed:
        if let object = interactiveTransitionObject {
          var percentage: CGFloat = (translation - initialTranslation) / maxTranslation
          
          // There seems to be a bug when the transitioning object is updated with a value >= 1.0.
          // When the object is at this value and finishInteractiveTransition() is called,
          // the From View temporarily flashes on the screen.
          if percentage > 0.99 {
            percentage = 0.99
          }
          
          // No need to check the bounds of "percentage."
          // The bounds are checked by the UIPercentDrivenInteractiveTransition object
          object.updateInteractiveTransition(percentage)
        }
        
      case .Ended:
        if let object = interactiveTransitionObject {
          var translation1: CGFloat = lastTranslation
          var translation2: CGFloat = translation
          if translation == lastTranslation {
            translation1 = priorToLastTranslation
            translation2 = lastTranslation
          }
          if translation1 < translation2 {
            object.finishInteractiveTransition()
          }
          else {
            object.cancelInteractiveTransition()
          }
        }
        reset()
        
      case .Possible, .Cancelled, .Failed:
        // The gesture recognizer may be cancelled when the device orientation changes.
        if true == isTransitioning {
          if let object = interactiveTransitionObject {
            object.cancelInteractiveTransition()
          }
        }
        
        reset()
        break
      }
      
      // We need to save two prior values because the final value may be equal to the last saved value.
      if translation != lastTranslation {
        priorToLastTranslation = lastTranslation
        lastTranslation = translation
      }
    }
  }
  
  private func adjustToCurrentOrientation() {
    if let view = view {
      if view is UIWindow {
        // If the given view is the application window,
        // adjust the edges based on the device orientation.
        // The window does not rotate with the device.
        switch UIDevice.currentDevice().orientation {
        case .LandscapeLeft:
          leftEdgeGestureRecognizer.edges = .Top
          rightEdgeGestureRecognizer.edges = .Bottom
        case .LandscapeRight:
          leftEdgeGestureRecognizer.edges = .Bottom
          rightEdgeGestureRecognizer.edges = .Top
        case .Portrait:
          leftEdgeGestureRecognizer.edges = .Left
          rightEdgeGestureRecognizer.edges = .Right
        case .PortraitUpsideDown:
          leftEdgeGestureRecognizer.edges = .Right
          rightEdgeGestureRecognizer.edges = .Left
        case .FaceDown, .FaceUp, .Unknown:
          // Do nothing.
          break
        }
      } else {
        leftEdgeGestureRecognizer.edges = .Left
        rightEdgeGestureRecognizer.edges = .Right
      }
    }
  }
}

