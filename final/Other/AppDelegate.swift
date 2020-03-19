/**
 * ----------------------------------------------------------------------------+
 * Created by: <System>
 * Filename: AppDelegate.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Last Modified: 03-18-2020
 * Description: A singleton that is to be shared among the classes
 * ----------------------------------------------------------------------------+
*/

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /**
     * Stores the time a =n animation should take before it is completed
    */
    public static let ANIMATION_DURATION: TimeInterval = TimeInterval(CGFloat(0.25))

    private let databaseCommunicator = DatabaseBuilder(databaseName: "MyDatabase.db")

    var window: UIWindow?

    // TODO: To be replaced byy a SQLite database
    private static let FAKE_REPO: Dictionary<ItemType, Dictionary<Int, StoreItem>> = [

        ItemType.book: [
            1: Book(title: "Test Title", description: "Test Description"),
            2: Book(title: "Test Title", description: "Test Description"),
            3: Book(title: "Test Title", description: "Test Description"),
            4: Book(title: "Test Title", description: "Test Description"),
            5: Book(title: "Test Title", description: "Test Description")
        ],
        ItemType.store: [
            1: Store(name: ""),
            2: Store(name: ""),
            3: Store(name: ""),
            4: Store(name: ""),
            5: Store(name: "")
        ]
    ]

    /**
     * Retrieves all of the items of a specific type that are in the stores list of items
     * - Parameters:
     *      - itemType: The type of the item you expect to get in return
    */
    public func findAll(itemType: ItemType) -> Array<StoreItem> {

        return AppDelegate.FAKE_REPO[itemType]?.values.filter({(item: StoreItem) in true}) ?? Array<StoreItem>()
    }

    /**
     * Retrieves a specific item that is in the stores list of items
     * - Parameters:
     *      - id: THe id of the item that is to be deleted
     *      - itemType: The type of the item you expect to get in return
    */
    public func findById(id: Int, itemType: ItemType) -> StoreItem {

        return AppDelegate.FAKE_REPO[itemType]?[id] ?? Store(name: "")
    }

    /**
     * Saves a single item to the stores list of items
     * - Parameters:
     *      - id: THe id of the item that is to be deleted
     *      - curve: The mathematical formula that the animation should follow
    */
    public func save(id: Int, item: StoreItem) -> Bool {

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // TODO: To delete shows a test of the query bridge utility (To be implemented into the *ById methods)
        // Inits the object to make sure the table mapping is registered
        Entries()

        func printValues(table: [Entries]) {

            print("\tThere is currently \(table.count) entries in the table")

            table.forEach({(entry: Entries) in

                print("\t\t\(entry.id)\t|\(entry.name)\t|\(entry.email)\t|\t\(entry.food)")
            })
        }

        print("Querying the 'entries' table")

        printValues(table: databaseCommunicator.querySelect(table: Entries.self, columns: nil) as! [Entries])

        print("Inserting values into the 'entries' table")
        databaseCommunicator.queryInsert(table: Entries.self, values: ["Test", "user@example.com", "Banana"])

        printValues(table: databaseCommunicator.querySelect(table: Entries.self, columns: nil) as! [Entries])
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

