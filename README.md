# InteractiveTransitionController
iOS Interactive Transition Controller

The `InteractiveTransitionController` class encapsulates most of the code required to navigate through a series of interactive transitions. The code sample shows an example implementation with three views and two interactive transitions.

For each transition, follow these steps to implement the controller:

1. Assign a view to detect gestures. A `UIScreenEdgePanGestureRecognizer` will be assigned to the left and right edges of the view. You can assign the application window or the presenting or dismissing view.

2. Assign which directions the edge gesture recognizer should detect: left, right or both. Use "right" to present a view and "left" to dismiss it. Your first view should only present a view and your last view should only dismiss.

3. Assign a delegate for the controller. The delegate should implement one or both of the `InteractiveTransitionControllerDelegate` protocol methods, depending on the supported navigation directions. When the `interactiveTransitionControllerStartRightTransition` method is called, the delegate is responsible for presenting the next view controller. When the `interactiveTransitionControllerStartLeftTransition` method is called, the delegate is responsible for unwinding to the previous view controller.

4. Use the interactive transitioning object supplied by the `InteractiveTransitionController`. You can access this object using the `newInteractiveTransitionObject` method. Return this object in the `interactionControllerForPresentation` and `interactionControllerForDismissal` methods of your `UIViewControllerTransitioningDelegate`.

Your code is responsible for supplying the transition animations.

If you use the application window for the gesture recognizer, you only need to assign it once at the beginning of the application. One functional difference is that gestures are cancelled on the window when a device is rotated. This won't happen if a view is used instead.

Deployment target: iOS 8.0

Built in Xcode 6.2

© 2015 Jose Villegas
