/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: HomeScreenViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Description: Handles the activities that occurs on the Home page
 * ----------------------------------------------------------------------------+
*/

import UIKit

public class HomeScreenViewController: HomeController {

    /**
     * Stores a copy of the UIView that is to be presented when the burger icon is hit
    */
    @IBOutlet
    private var slideoutMenu: UIView?

    /**
     * Stores a copy of the UIView for the notification bubble
    */
    @IBOutlet
    private var lblNotificationCount: UILabel?

    /**
     * Stores a copy of the Segmented control that determines which resources to display
    */
    @IBOutlet
    private var segResourceType: UISegmentedControl?

    /**
     * Stores a copy of the Text field that contains the query of the user
    */
    @IBOutlet
    private var textSearch: UITextField?

    /**
     * Stores the Button that is assigned to the burger icon
    */
    @IBOutlet
    private var burgerIcon: UIButton?

    /**
     * Stores the endpoint url that is used to grab new books
    */
    private static let BOOK_API_ENDPOINT: URL = URL(string: "https://api.itbook.store/1.0/new")!


    /**
     * Stores the location of the menu at each VisibilityState
    */
    private var slidoutMenuProperties: [VisibilityState: CGRect]?

    /**
     * Stores a copy of the applications delegate
    */
    private let sharedDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    public let maxNotifications: Int = 5

    private var _notificationCount: Int = 0

    public var notificationCount: Int {

        get {

            return _notificationCount
        } set {

            if (newValue < 0) {

                return
            }

            if (newValue > maxNotifications) {

                lblNotificationCount?.text = "\(maxNotifications)+"
            } else {

                lblNotificationCount?.text = String(newValue)
            }

            lblNotificationCount?.isHidden = newValue == 0

            _notificationCount = newValue
        }
    }

    /**
     * Grabs books from the API endpoint and adds them to the database
    */
    public func grabBooks() {

        var request = URLRequest(url: HomeScreenViewController.BOOK_API_ENDPOINT)

        // Assigns the HTTP method that will be used
        request.httpMethod = "GET"

        // Adds the appropriate headers to the request
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            do {
                //Retrieves the data from the JSON response
                let jsonObject: Array<Dictionary<String, Any>> = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        as? [String: Any])!["books"] as! Array<Dictionary<String, Any>>

                // Adds each book to the database
                for book in jsonObject {

                    self.sharedDelegate.save(table: Book.self, values: [book["title"], book["subtitle"]])
                }

                DispatchQueue.main.async {

                    self.invalidaateTable()
                }
            } catch let error {

                print(error.localizedDescription)
            }
        })

        task.resume()
    }

    /**
     * An event that is fired when the view is loaded into memory
    */
    override public func viewDidLoad() {
        super.viewDidLoad()

        sharedDelegate.findAll(table: Store.self)

        if (sharedDelegate.findAll(table: Book.self).count <= 0) {

            grabBooks()
        }

        lblNotificationCount?.makeCircle()
        notificationCount = 100

        sharedDelegate.setNotificationCount = {(newValue: Int) in

            self.notificationCount = newValue
        }

        sharedDelegate.getNotificationCount = {() in

            return self.notificationCount;
        }

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

        exitSlideOut.setBackgroundImage(UIImage(named: "close"), for: .normal)

        /**
         * Register an 'TouchUpInside' event so that the menu disappears
        */
        exitSlideOut.addTarget(self, action: #selector(hideMenu), for: .touchUpInside)

        slideoutMenu?.addSubview(exitSlideOut)
        slideoutMenu?.addSubview(blurEffectView)

        parseResourceType(segResourceType!)
    }

    /**
     * Parses the correct resource that the user wants to be shown
     * - Parameters:
     *      - sender: The segmented control that initialized the event
    */
    @IBAction
    public func parseResourceType(_ sender: UISegmentedControl) {

        if (sender.selectedSegmentIndex == 0) {

            viewing = Book.self
        } else if (sender.selectedSegmentIndex == 1) {

            viewing = Store.self
        }

        textSearch?.text = ""
        modifyFilter(textSearch!)
    }

    @IBAction
    public func modifyFilter(_ sender: UITextField) {

        if (sender.text! == "") {

            searchFilter = nil
        } else {

            searchFilter = { (object: DatabaseItem) in

                return object.name.lowercased().contains((sender.text!.lowercased()))
            }
        }

        invalidaateTable()
    }

    /**
     * A function created to expose the menu states to Objective-C
     * - Parameters:
     *      - gesture: TThe gesture that was performed by the user
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
     * - Parameters:
     *      - sender: The object that initialized the event
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

    /**
     * Allows ViewController to perform an unwind segue
     * - Parameters:
     *      - sender: The object that initialized the event
    */
    @IBAction
    public func unwindToHome(_ sender: UIStoryboardSegue) {

        hideMenu(sender: sender)
    }
}
