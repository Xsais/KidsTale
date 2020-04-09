/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: DatabaseItems.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Description: Houses all classes the relate to an item in the database
 * ----------------------------------------------------------------------------+
*/

import Foundation

public class DatabaseItem {

    // Stores the title of the book
    public var name: String!

    // Stores the description of the book
    public var description: String!

    fileprivate var _id: Int?

    public var id: Int? {
        get {
            return _id
        }
    }

    // Stores the columns descriptor for each column in the table
    private static var _columnDescriptors: [String: Array<ColumnDescriptor>] = [:]

    /**
     * Retrieves the descriptors that describes information about the table columns
     * - Parameters:
     *      - table: The table in which to get the descriptors for
    */
    public static func getDescriptors(table: DatabaseItem.Type) -> Array<ColumnDescriptor> {

        return _columnDescriptors[String(describing: table)]!
    }

    /**
     * Allows subclasses to map properties to columns in the table columns
     * - Parameters:
     *      - table: THe table in which to get the descriptors for
    */
    fileprivate static func registerColumn(table: DatabaseItem.Type, columns: ColumnDescriptor...) {

        // If the table is already registered do not allow it to be re-registered
        if (_columnDescriptors[String(describing: table)] != nil) {

            return
        }

        _columnDescriptors[String(describing: table)] = columns
    }
}

/**
 * Represents a book object that belongs to the store
*/
public class Book: DatabaseItem, Resource {

    /**
     * Creates a new book object with the required data
     * - Parameters:
     *      - title: The desired title of the book
     *      - description: The desired description of the book
    */
    public convenience init(name: String, description: String) {

        self.init()

        self.name = name
        self.description = description
    }

    /**
     * Allows the creation of an blank book
    */
    private override init() {

        super.init()
    }

    /**
     * The place were all of the 'ColumnDescriptors' are registered
    */
    public static func initDescriptors() {

        // Registers all of the columns the are in the book table
        DatabaseItem.registerColumn(table: Book.self, columns:
        ColumnDescriptor(isAuto: true, columnName: "ID", columnType: .integer),
                ColumnDescriptor(columnName: "name", columnType: .text),
                ColumnDescriptor(columnName: "description", columnType: .text))
    }

    /**
     * Allows the creation of an book from a table query look-up
     * - Parameters:
     *      - columns: The table columns that the book properties will be initialized with
    */
    public static func initWithColumnDescriptors(columns: Dictionary<ColumnDescriptor, Any>) -> DatabaseItem {

        let builtItem: Book = Book()

        // Searches throw each 'ColumnDescriptor' for the fields required to initialize the book
        columns.forEach({ (column: ColumnDescriptor, value: Any) in

            switch (column.name) {

            case "ID":

                builtItem._id = (value as! Int)
                break
            case "name":

                builtItem.name = (value as! String)
                break
            case "description":

                builtItem.description = (value as! String)
                break
            default:
                break
            }
        })

        return builtItem
    }
}

/**
 * Represents a physical store object that belongs to the online store
*/
public class Store: DatabaseItem, Resource {

    // Stores the location of the store to be consumed by the map API
    public var location: String?

    /**
     * Allows the creation of an physical store
     * - Parameters:
     *      - name: The desired name of the physical store
    */
    public convenience init(name: String) {

        self.init()

        self.name = name
    }

    /**
     * Allows the creation of an blank physical store
    */
    private override init() {

        super.init()
    }

    /**
     * The place were all of the 'ColumnDescriptors' are registered
    */
    public static func initDescriptors() {

        // Registers all of the columns the are in the store table
        DatabaseItem.registerColumn(table: Store.self, columns:
        ColumnDescriptor(isAuto: true, columnName: "ID", columnType: .integer),
                ColumnDescriptor(columnName: "name", columnType: .text),
                ColumnDescriptor(columnName: "description", columnType: .text),
                ColumnDescriptor(columnName: "location", columnType: .text))
    }

    /**
     * Allows the creation of an store from a table query look-up
     * - Parameters:
     *      - columns: The table columns that the store properties will be initialized with
    */
    public static func initWithColumnDescriptors(columns: Dictionary<ColumnDescriptor, Any>) -> DatabaseItem {

        let builtItem: Store = Store()

        // Searches throw each 'ColumnDescriptor' for the fields required to initialize the book
        columns.forEach({ (column: ColumnDescriptor, value: Any) in

            switch (column.name) {

            case "ID":

                builtItem._id = (value as! Int)
                break
            case "name":

                builtItem.name = (value as! String)
                break
            case "description":

                builtItem.description = (value as! String)
                break
            case "location":

                builtItem.location = (value as! String)
                break
            default:
                break
            }
        })

        return builtItem
    }
}
