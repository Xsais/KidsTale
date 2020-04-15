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
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /**
     * Stores the name of the database that is to be used throughout the application
    */
    private static let DATABASE_NAME : String = "KidsTale.db"
    
    /**
     * Stores the name of the database that is to be used throughout the application
    */
    public static let validAnimations : [String: String] = ["Blink": "opacity", "Grow": "transform.scale"]
    
    /**
     * Stores the animation that will be applied to the notification dot when a message is recieved
    */
    public var appliedAnimation : String = AppDelegate.validAnimations["Blink"]!
  
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
     * Stores the item that is selected on the HomeScreen
    */
    public var selectedItem: DatabaseItem?

    /**
     * Stores the volume the application will use
    */
    public var applicationVolume: Float = 50

    /**
     * Retrieves and assigns the current amount of notification, only if the handlers have been registered
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
     * Stores the handler  that will be used to communicate with the database
    */
    private let databaseCommunicator = DatabaseBuilder(databaseName: DATABASE_NAME)
    
    var databasePath : String?
    
    var storeData : [Store] = []
    
    //created variable to store selected store and it's location <Jie Ming Wu >
    var storeLocation : String?
    var LocationChoise : String = "OFF"
    var InputLocation : String?
    
    //<Jie Ming Wu>
    
    /**
     * Stores the current window that is presented to the user
    */
    var window: UIWindow?

    /**
      * Retrieves all of the items of a specific type that are in the stores list of items
      * - Parameters:
      *      - table: The type of the item you expect to get in return
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
    */
    public func findAll(table: DatabaseItem.Type, filter: (DatabaseItem) -> Bool) -> Array<DatabaseItem> {

        return findAll(table: table).filter(filter)
    }

    /**
     * Retrieves the index of the {@see cachedResults} is the cached query results stored
     * - Parameters:
     *      - table: The type of the item you expect to get in return
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
         
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
         let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + AppDelegate.DATABASE_NAME)
          checkAndCreateDatabase()
         readDataFromDatabase()
        
        return true
    }
     
    func checkAndCreateDatabase(){
         var success = false
         let fileManager = FileManager.default
         success = fileManager.fileExists(atPath: databasePath!)
         if success {
             return
         }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + AppDelegate.DATABASE_NAME)
     
         try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
         
         return
     }
    
    func readDataFromDatabase(){
        storeData.removeAll()
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "Select * from store"
            
            //create table StoreInfo(ID integer Primary key, StoreName text, StoreLocation text, StoreDescription text, StoreHour text,StoreImage text);

            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil)
                == SQLITE_OK{
                while sqlite3_step(queryStatement) == SQLITE_ROW{
                    //extract the row to the data object
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cstorename = sqlite3_column_text(queryStatement, 1)
                    let cstorelocation = sqlite3_column_text(queryStatement, 2)
                    let cdescription = sqlite3_column_text(queryStatement, 3)
                      let cstorehour = sqlite3_column_text(queryStatement, 4)
                     let cstoreimage = sqlite3_column_text(queryStatement, 5)
                    
                    let storename = String(cString: cstorename!)
                    let storelocation = String(cString: cstorelocation!)
                    let storedescription = String(cString: cdescription!)
                    let storehour = String(cString: cstorehour!)
                    let storeimage = String(cString: cstoreimage!)
                    
                    
                    let data : Store = Store.init(name: storename)
                        data.initWithData(theRow: id, storeLocation: storelocation, storeDescription: storedescription, storeHour: storehour, storeImage: storeimage)
                    storeData.append(data)
                    print("query result")
                    print("\(id) | \(storename) | \(storelocation) | \(storedescription)")
                    
                }
                sqlite3_finalize(queryStatement)
            }else{
                print("Unable to open database1")
            }
            sqlite3_close(db)
        }else{
            print("Unable to open database2")
        }
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

