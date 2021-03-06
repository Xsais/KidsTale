/**
 * ----------------------------------------------------------------------------+
 * Created by: <System>
 * Filename: AppDelegate.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Description: A singleton that is to be shared among the classes
 * ----------------------------------------------------------------------------+
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /**
     * Stores the name of the database that is to be used throughout the application
    */
    private static let DATABASE_NAME: String = "KidsTale.db"

    /**
     * Stores the name of the database that is to be used throughout the application
    */
    public static let validAnimations: [String: String] = ["Blink": "opacity", "Grow": "transform.scale"]

    /**
     * The typealias responsible for handling getting a value
     */
    typealias HandleGetValue = () -> Any
    
    /**
     * The typealias responsible for handling setting a value
     */
    typealias HandleSetValue = (Any) -> Void
    
    /**
     * Stores the expresion used to set the notification count
     */
    public var setNotificationCount: HandleSetValue? = nil
    
    /**
     * Stores the expresion used to get the notification count
     */
    public var getNotificationCount: HandleGetValue? = nil

    /**
     * Stores the animation that will be applied to the notification dot when a message is recieved
    */
    public var appliedAnimation: String = AppDelegate.validAnimations["Blink"]!

    /**
     * Stores the time the last query results that were called to a specific table
    */
    private var cachedResults: Array<Array<DatabaseItem>> = Array()

    /**
     * Stores the "tables" that have already been queried, also acts as an index for "cachedResults"
    */
    private var cachedResultIndexes: Array<DatabaseItem.Type> = Array()

    /**
     * Stores the time an animation should take before it is completed
    */
    public static let ANIMATION_DURATION: TimeInterval = TimeInterval(CGFloat(0.25))

    /**
     * Stores the item that is selected on the HomeScreen
     * - Author(s):
     *      - Nathaniel Primo
    */
    public var selectedItem: DatabaseItem?

    /**
     * Stores the volume the application will use
     * - Author(s):
     *      - Nathaniel Primo
    */
    public var applicationVolume: Float = 50
    
    /**
     Chat Service class object
     * - Author(s):
     *      - Heon Lee
     */
    public var chatService : ChatService?
    
    /**
     * Check if the user is in the coatrooms
     * - Author(s):
     *      - Heon Lee
     */
    public var inChat : Bool?
    
    /**
     * New messages when the user was not in the chat
     * - Author(s):
     *      - Heon Lee
     */
    public var newMessages = [Message]()
    
    /**
     * Remember the username
     * - Author(s):
     *      - Heon Lee
     */
    public var username : String?

    /**
     * Stores the handler  that will be used to communicate with the database
     * - Author(s):
     *      - Nathaniel Primo
    */
    private let databaseCommunicator = DatabaseBuilder(databaseName: AppDelegate.DATABASE_NAME)

    /**
     * Stores to location of the store
     * - Author(s):
     *      - Jie Ming Wu
    */
    var storeLocation: String?

    /**
     * Stores the user choice to store the location, set Location choice to default value OFF
     * - Author(s):
     *      - Jie Ming Wu
    */
    var LocationChoice: String = "OFF"

    /**
     * Stores the user inputted location
     * - Author(s):
     *      - Jie Ming Wu
    */
    var InputLocation: String?

    /**
     * Stores the current window that is presented to the user
    */
    var window: UIWindow?

    /**
      * Retrieves all of the items of a specific type that are in the stores list of items
      * - Parameters:
      *      - table: The type of the item you expect to get in return
      *
      * - Author(s):
      *      - Nathaniel Primo
     */
    public func findAll(table: DatabaseItem.Type) -> Array<DatabaseItem> {

        let cachedIndex: Int = getCacheIndex(table: table)

        if (cachedIndex != -1) {

            return cachedResults[cachedIndex]
        }

        let queriedList: Array<DatabaseItem> = databaseCommunicator.querySelect(table: table as! InitDelegate.Type, columns: nil)

        cachedResultIndexes.append(table)

        cachedResults.append(queriedList)

        return queriedList
    }

    /**
     * Retrieves all of the items of a specific type that are in the stores list of items
     * - Parameters:
     *      - table: The type of the item you expect to get in return
     *      - filter: The filter that should be applied to the items the were fetched
     *
     * - Author(s):
     *      - Nathaniel Primo
    */
    public func findAll(table: DatabaseItem.Type, filter: (DatabaseItem) -> Bool) -> Array<DatabaseItem> {

        return findAll(table: table).filter(filter)
    }

    /**
     * Retrieves and assigns the current amount of notification, only if the handlers have been registered
     *
     * - Author(s):
     *      - Nathaniel Primo
     */
    public var notificationCount: Int {
        get {
            
            if (getNotificationCount == nil) {

                return -1
            }
            
            return getNotificationCount!() as! Int
        }
        set {
            
            if (setNotificationCount == nil) {

                return
            }
            
            setNotificationCount!(newValue)
        }
    }
    
    /**
     * Retrieves the index of the {@see cachedResults} is the cached query results stored
     * - Parameters:
     *      - table: The type of the item you expect to get in return
     *
     * - Author(s):
     *      - Nathaniel Primo
    */
    private func getCacheIndex(table: DatabaseItem.Type) -> Int {

        var desiredIndex: Int = 0;

        var wasFound: Bool = false

        for delegate in cachedResultIndexes {

            if (delegate == table) {

                wasFound = true
                break
            }

            desiredIndex += 1;
        }

        return wasFound ? desiredIndex : -1;
    }

    /**
     * Retrieves a single item from the table, either from the cache or directly from the database
     * - Parameters:
     *      - table: The type of the item you expect to get in return
     *      - index: The desired index in which to be pulled
     *
     * - Author(s):
     *      - Nathaniel Primo
    */
    public func getSingleResource(table: DatabaseItem.Type, index: Int) -> DatabaseItem {

        let cachedIndex: Int = getCacheIndex(table: table)

        if (cachedIndex != -1) {

            return cachedResults[cachedIndex][index]
        }

        return findAll(table: table)[index]
    }

    /**
     * Retrieves a single item from the table, either from the cache or directly from the database
     * - Parameters:
     *      - table: The type of the item you expect to get in return
     *      - index: The desired index in which to be pulled
     *      - filter: The filter that should be applied to the items the were fetched
     *
     * - Author(s):
     *      - Nathaniel Primo
    */
    public func getSingleResource(table: DatabaseItem.Type, index: Int, filter: (DatabaseItem) -> Bool) -> DatabaseItem {

        let cachedIndex: Int = getCacheIndex(table: table)

        if (cachedIndex != -1) {

            return cachedResults[cachedIndex].filter(filter)[index]
        }

        return findAll(table: table).filter(filter)[0]
    }

    /**
     * Saves a single item to the stores list of items
     * - Parameters:
     *      - table: The type of the item you expect to get in return
     *      - values: The mathematical formula that the animation should follow
     *
     * - Author(s):
     *      - Nathaniel Primo 
    */
    public func save(table: DatabaseItem.Type, values: [Any]) -> DatabaseItem {

        let queriedResult: DatabaseItem = databaseCommunicator.queryInsert(table: table as! InitDelegate.Type, values: values) as! DatabaseItem

        let cachedIndex: Int = getCacheIndex(table: table)

        if (cachedIndex == -1) {

            cachedResultIndexes.append(table)

            cachedResults.append([queriedResult])
        } else {

            cachedResults[cachedIndex].append(queriedResult)
        }

        return queriedResult
    }

    /**
     * The event that is executed when the application first starts
     * - Parameters:
     *      - application: The application that has been started
     *      - launchOptions: Any options that have been passed with the application launch
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        return true
    }

    /**
     *  Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     * Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     * - Parameters:
     *      - application: The application that has been started
    */
    func applicationWillResignActive(_ application: UIApplication) {
    }

    /**
     * Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     * If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     * - Parameters:
     *      - application: The application that has been started
    */
    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    /**
     * Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     * - Parameters:
     *      - application: The application that has been started
    */
    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    /**
     * Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     * - Parameters:
     *      - application: The application that has been started
    */
    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    /**
     * TCalled when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     * - Parameters:
     *      - application: The application that has been started
    */
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

