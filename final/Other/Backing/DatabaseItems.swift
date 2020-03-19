/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: DatabaseItems.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Last Modified: 03-18-2020
 * Description: Houses all classes the relate to an item in the database
 * ----------------------------------------------------------------------------+
*/

import Foundation

public class DatabaseItem {

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
public class Book: DatabaseItem, StoreItem {

    // Stores the title of the book
    public var title: String?

    // Stores the description of the book
    public var description: String?

    /**
     * Creates a new book object with the required data
     * - Parameters:
     *      - title: The desired title of the book
     *      - description: The desired description of the book
    */
    public convenience init(title: String, description: String) {

        self.init()

        self.title = title
        self.description = description
    }

    /**
     * Creates and sets-up the book object to connect with the database
    */
    private override init() {

        super.init()

        Book.initDescriptors()
    }

    /**
     * The place were all of the 'ColumnDescriptors' are registered
    */
    public static func initDescriptors() {

        // Registers all of the columns the are in the book table
        DatabaseItem.registerColumn(table: Book.self, columns:
        ColumnDescriptor(isAuto: true, columnName: "ID", columnType: .integer),
                ColumnDescriptor(columnName: "title", columnType: .text),
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

            if (column.name == "title") {

                builtItem.title = (value as! String)
            } else if (column.name == "description") {

                builtItem.description = (value as! String)
            }
        })

        return builtItem
    }
}

/**
 * Represents a physical store object that belongs to the online store
*/
public class Store: DatabaseItem, StoreItem {

    // Stores the name of the physical store
    public var name: String?

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
     * Allows the creation of an physical store whilst binding the object to a specific table
     * - Parameters:
     *      - name: The desired name of the physical store
    */
    private override init() {

        super.init()

        Store.initDescriptors()

    }

    /**
     * The place were all of the 'ColumnDescriptors' are registered
    */
    public static func initDescriptors() {

        // Registers all of the columns the are in the store table
        DatabaseItem.registerColumn(table: Store.self, columns:
        ColumnDescriptor(isAuto: true, columnName: "ID", columnType: .integer),
                ColumnDescriptor(columnName: "name", columnType: .text))
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

            if (column.name == "name") {

                builtItem.name = (value as! String)
            }
        })

        return builtItem
    }
}

// TODO: This is to be deleted, it only exists for example purposes
public class Entries: DatabaseItem, StoreItem {

    // Stores the id of the object as it is in the table
    private var _id: Int?

    // Stores the name of the object as it is in the table
    private var _name: String?

    // Stores the email of the object as it is in the table
    private var _email: String?

    // Stores the food of the object as it is in the table
    private var _food: String?

    // Stores the id of the object as it is in the table
    public var id: Int? { get { return _id }}

    // Stores the name of the object as it is in the table
    public var name: String? { get { return _name }}

    // Stores the email of the object as it is in the table
    public var email: String? { get { return _email }}

    // Stores the food of the object as it is in the table
    public var food: String? { get { return _food }}

    public override init() {

        super.init()

        Entries.initDescriptors()
    }

    /**
     * The place were all of the 'ColumnDescriptors' are registered
    */
    public static func initDescriptors() {

        // Binds the entries table to the object
        DatabaseItem.registerColumn(table: Entries.self, columns:
        ColumnDescriptor(isAuto: true, columnName: "ID", columnType: .integer),
                ColumnDescriptor(columnName: "name", columnType: .text),
                ColumnDescriptor(columnName: "email", columnType: .text),
                ColumnDescriptor(columnName: "food", columnType: .text))
    }

    // TODO: This method is blank because the value are not needed se above for
    public static func initWithColumnDescriptors(columns: Dictionary<ColumnDescriptor, Any>) -> DatabaseItem {

        let builtItem: Entries = Entries()

        // Searches throw each 'ColumnDescriptor' for the fields required to initialize the book
        columns.forEach({ (column: ColumnDescriptor, value: Any) in

            if (column.name == "name") {

                builtItem._name = (value as! String)
            } else if (column.name == "ID") {

                builtItem._id = (value as! Int)
            } else if (column.name == "email") {

                builtItem._email = (value as! String)
            } else if (column.name == "food") {

                builtItem._food = (value as! String)
            }
        })
        return builtItem
    }
}
