/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: HomeScreenViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Last Modified: 03-08-2020
 * Description: Handles the activities that occurs on the Home page
 * ----------------------------------------------------------------------------+
*/

import UIKit

public class HomeScreenViewController: SmartUIViewController {

    /**
     * Stores a copy of the UIView that is to be presented when the burger icon is hit
    */
    @IBOutlet
    private var slideoutMenu: UIView?

    /**
     * Stores the Button that is assigned to the burger icon
    */
    @IBOutlet
    private var burgerIcon: UIButton?

    /**
     * Stores the location of the menu at each VisibilityState
    */
    private var slidoutMenuProperties: [VisibilityState: CGRect]?

    /**
     * An event that is fired when the view is loaded into memory
    */
    override public func viewDidLoad() {
        super.viewDidLoad()

        /**
          * Registers a swipe gesture to be fired when the user swipes right on the screen
         */
        var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeMenuStateC))

        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)

        /**
          * Registers a swipe gesture to be fired when the user swipes left on the screen
         */
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeMenuStateC))

        swipeGesture.direction = .left
        self.view?.addGestureRecognizer(swipeGesture)

        slidoutMenuProperties = [

            .hidden: CGRect(x: -1 * (slideoutMenu?.frame.width ?? 0), y: 0, width: (slideoutMenu?.frame.width ?? 0), height: (slideoutMenu?.frame.height ?? 0)),
            .visible: slideoutMenu!.frame
        ]

        /**
         * Changes the current state of the pull out menu
        */
        changeMenuState(isVisible: .hidden, duration: TimeInterval(CGFloat(0)), curve: .linear)

        /**
         * Creates and introduces the button that will dismiss the pull out menu
        */
        let exitSlideOut: UIButton = UIButton()

        exitSlideOut.frame = CGRect(x: (slideoutMenu?.frame.width ?? 0) - (burgerIcon?.frame.width ?? 0) - (burgerIcon?.frame.minX ?? 0), y: (burgerIcon?.frame.minY ?? 0), width: burgerIcon?.frame.width ?? 0, height: burgerIcon?.frame.height ?? 0)

        /**
         * Stores the Effect that gives the illusion that the menu is floating
        */
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = CGRect(x: slideoutMenu?.frame.width ?? 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        exitSlideOut.backgroundColor = .black

        /**
         * Register an 'TouchUpInside' event so that the menu disappears
        */
        exitSlideOut.addTarget(self, action: #selector(hideMenu), for: .touchUpInside)

        slideoutMenu?.addSubview(exitSlideOut)
        slideoutMenu?.addSubview(blurEffectView)
    }

    /**
     * A function created to expose the menu states to Objective-C
    */
    @objc
    private func changeMenuStateC(gesture: UISwipeGestureRecognizer) {

        switch (gesture.direction) {
            
            case .right:
                showMenu(sender: gesture)
            case .left:
                hideMenu(sender: gesture)
            default:
                break;
        }
    }

    /**
     * An event handler that goal is to show the menu to the user
    */
    @IBAction
    private func showMenu(sender: Any?) {

        changeMenuState(isVisible: .visible, duration: nil, curve: .linear)
    }

    /**
     * An event handler that goal is to hide th menu from the user
    */
    @IBAction
    private func hideMenu(sender: Any?) {

        changeMenuState(isVisible: .hidden, duration: nil, curve: .linear)
    }

    /**
     * Changes the current state of the menu via an animation
     * - Parameters:
     *      - isVisible: Weather the menu is (VisibilityState.visible) or (VisibilityState.hidden)
     *      - duration: The amount of time it should take to complete the animation
     *      - curve: The mathematical formula that the animation should follow
    */
    public func changeMenuState(isVisible: VisibilityState, duration: TimeInterval?, curve: UIView.AnimationCurve) {

        let animator = UIViewPropertyAnimator(duration: duration ?? AppDelegate.ANIMATION_DURATION, curve: curve)

        /**
         * The handler that gets invoked when the animation is complete
        */
        animator.addCompletion() { position in

            /**
             *Changes the tag of the menu so that the state can be recorded
            */
            self.slideoutMenu?.tag = isVisible.rawValue;
            self.ignoreResponders()

            /**
             * Hides the menu once it is no longer on the screen
            */
            if (isVisible == .visible) {

                return
            }

            self.acknowledgeResponders()

            self.slideoutMenu?.isHidden = true
        }

        /**
         * Depending on the VisibilityState that was provide trigger different animations
        */
        switch (isVisible) {

        case .hidden:

            animator.addAnimations() {

                self.slideoutMenu?.frame = self.slidoutMenuProperties![.hidden]!
            }
        case .visible:

            self.slideoutMenu?.isHidden = false

            // Clears the keyboard from the screen
            self.resignFirstResponder(nil)

            animator.addAnimations() {

                self.slideoutMenu?.frame = self.slidoutMenuProperties![.visible]!
            }
        case .gone:
            break
        }

        animator.startAnimation()
    }
    
    @IBAction
    public func unwindToHome(_ sender: UIStoryboardSegue) {
        
        hideMenu(sender: sender)
    }
}
