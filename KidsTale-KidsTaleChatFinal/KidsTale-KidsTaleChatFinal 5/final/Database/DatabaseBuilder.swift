/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: DatabaseBuilder.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Description: Acts as a bridge to SQLite database, statements simplifying a reducing errors
 * ----------------------------------------------------------------------------+
*/

import Foundation
import SQLite3

public class DatabaseBuilder {

    // Stores the name of the SQLite database
    public let databaseName: String

    // Store the path of the SQLite databe on the phones filesystem
    private let databasePath: String

    // Store a copy of the current pointer to the opened SQLite database
    private var databaseReference: OpaquePointer? = nil

    /**
     * Close the connection to the SQLite database upon removing the object from memory
    */
    deinit {

        closeConnection()
    }

    /**
     * Creates a new interface to the SQLite database
     * - Parameters:
     *      - databaseName: The name of the database file as it is on the file system
    */
    public init(databaseName: String) {

        self.databaseName = databaseName

        // Retrieves the path of the database as it is on the phones internal filesystem
        databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/" + databaseName)

        // Copies the database if needed
        checkAndCreateDatabase(databaseName: databaseName)
    }

    /**
     * Opens an active connection to the SQLite database
    */
    public func openConnection() {

        // In the case the connection is open, close it first
        if (databaseReference != nil) {

            closeConnection()
        }

        if (sqlite3_open(self.databasePath, &databaseReference) == SQLITE_OK) {

            return
        }
    }

    /**
     * Closes the active connection to the SQLite database
    */
    public func closeConnection() {

        // If the connection is already closed ignore the request
        if (databaseReference == nil) {

            return
        }

        sqlite3_close(databaseReference)
    }

    /**
     * Checks if the file already exist on the phones internal file system, if it does not copy it
     * - Parameters:
     *      - databaseName: The name of the database file as it is on the file system
    */
    private func checkAndCreateDatabase(databaseName: String) {

        // In the case the file alreaady exist do nothing
        if (FileManager.default.fileExists(atPath: self.databasePath)) {
            return
        }

        // Copy the file to the correct location
        try! FileManager.default.copyItem(atPath: (Bundle.main.resourcePath?.appending("/" + databaseName))!, toPath: self.databasePath)
    }

    /**
     * Applies static initiation of the table
     * - Parameters:
     *      - table: The table in question that will be queried
    */
    private func initQuery(table: InitDelegate.Type) {

        table.initDescriptors()
    }

    /**
     * Executes a selection query to the database
     * - Parameters:
     *      - table: The table in question that will be queried
     *      - columns: The required columns to select from, if nil all columns will be garbed (SELECT *)
     * - Returns: An array of the specified 'table' object, the is pulled using the query
    */
    public func querySelect(table: InitDelegate.Type, columns: [ColumnDescriptor]?) -> [DatabaseItem] {

        initQuery(table: table)

        // Stores the columns that will be used for the query
        var usedColumn: [ColumnDescriptor]

        // The 'StringBuilder' that will be used to hold the query statement
        var queryStatement: String = "SELECT "

        // determines weather a argument has been apended to the string
        var hasAppended: Bool = false

        // Determine weather all columns need to be garbed (SELECT *)
        if (columns == nil) {

            queryStatement += "*"

            // Retrieves a list of the 'ColumnDescriptors' for the specified table
            usedColumn = DatabaseItem.getDescriptors(table: table as! DatabaseItem.Type)
        } else {

            usedColumn = columns!

            // Appends the required selected columns to the select statement
            for column: ColumnDescriptor in columns! {

                if (hasAppended) {

                    queryStatement += ","
                }

                queryStatement += "\(column.name)"

                hasAppended = true
            }
        }

        queryStatement += " FROM \(String(describing: table))"

        var returnedItems: [DatabaseItem] = []

        var queryReference: OpaquePointer? = nil

        // Opens a connection to the database
        openConnection()

        // Setup object that will handle data transfer
        if sqlite3_prepare_v2(databaseReference, queryStatement, -1, &queryReference, nil) == SQLITE_OK {

            // Loop through row by row to extract dat
            while (sqlite3_step(queryReference) == SQLITE_ROW) {

                // Extract columns data, convert to the 'ColumnDescriptor' required string
                var objectDescriptor: Dictionary<ColumnDescriptor, Any> = Dictionary()

                for column in usedColumn {

                    // Retrieves the index of the column, using reverse lookup
                    let columnIndex: Int32 = Int32(usedColumn.firstIndex(of: column)!)

                    // Determines which statement to call depending on the type of the column specified by the 'ColumnDescriptor'
                    switch (column.type) {

                    case .text:

                        objectDescriptor[column] = String(cString: sqlite3_column_text(queryReference, columnIndex))
                        break

                    case .integer:

                        objectDescriptor[column] = Int(sqlite3_column_int(queryReference, columnIndex))
                        break
                    }
                }

                // Apends the created item to the array of all items returned
                returnedItems.append(table.initWithColumnDescriptors(columns: objectDescriptor))

            }

            // Clean up the query reference that was used
            sqlite3_finalize(queryReference)
        }

        // Closes the connection to the database
        closeConnection()

        return returnedItems
    }

    /**
     * Inserts a new row into a table, with the specified values
     * - Parameters:
     *      - table: The table in question that will be queried
     *      - values: The The values that is required to be inserted into the database, minus the auto generated fields
    */
    public func queryInsert(table: InitDelegate.Type, values: [Any]) -> InitDelegate {

        initQuery(table: table)

        // Retrieves the 'ColumnDescriptors' that is used to describe the table
        let columns: [ColumnDescriptor] = DatabaseItem.getDescriptors(table: table as! DatabaseItem.Type)

        // The 'StringBuilder' that is to be used to hold the insertion query
        var queryStatement: String = "INSERT INTO \(String(describing: table))("

        // The 'StringBuilder' that is to be used to hold the insertion values
        var queryValues: String = "("

        // Determines weather the string has had values amended to it
        var hasAppended: Bool = false

        // Stores the columns that will be skipped because they are auto generated
        var skipIndex: [ColumnDescriptor] = []

        // Appends the required values to the to the insertion statement
        columns.forEach({ (descriptor: ColumnDescriptor) in

            // Appends a comma to query if it is required
            if (hasAppended) {

                queryStatement += ","
                queryValues += ",";
            }

            queryStatement += "\(descriptor.name)"

            if (descriptor.isAuto) {

                queryValues += "NULL"
                skipIndex.append(descriptor)
            } else {

                queryValues += "?"
            }

            hasAppended = true
        })

        queryStatement = "\(queryStatement)) VALUES\(queryValues))"

        var queryReference: OpaquePointer? = nil

        // Opens a connection the the SQLite database
        openConnection()

        var initDescriptors: Dictionary<ColumnDescriptor, Any> = Dictionary()

        // Setup object that will handle data transfer
        if sqlite3_prepare_v2(databaseReference, queryStatement, -1, &queryReference, nil) == SQLITE_OK {

            // Binds the required fields using the 'ColumnDescriptor'
            columns.forEach({ (descriptor: ColumnDescriptor) in

                // Skips if the column is auto generated
                if (skipIndex.firstIndex(of: descriptor) != nil) {

                    return
                }

                // Retrieves the index of the column, using reverse lookup
                let columnIndex: Int = columns.firstIndex(of: descriptor)!
                let columnIndex32: Int32 = Int32(columnIndex)

                // Calculates the index that is needed to access the array
                let valueIndex: Int = columnIndex - skipIndex.count

                initDescriptors[descriptor] = values[valueIndex]

                switch (descriptor.type) {

                case .text:

                    sqlite3_bind_text(queryReference, columnIndex32, (values[valueIndex] as! NSString).utf8String, -1, nil)
                    break

                case .integer:

                    sqlite3_bind_int(queryReference, columnIndex32, Int32(values[valueIndex] as! Int))
                    break
                }
            });

            // Places the values into the table using the insertion query
            sqlite3_step(queryReference)

            //Clean up
            sqlite3_finalize(queryReference)
        }

        closeConnection()

        return table.initWithColumnDescriptors(columns: initDescriptors) as! InitDelegate
    }

    /**
     * Inserts a new row into a table, with the specified values
     * - Parameters:
     *      - table: The table in question that will be queried
     *      - values: The The values that is required to be inserted into the database, minus the auto generated fields
    */
    public func queryUpdate(table: InitDelegate.Type, values: [Any?]) -> InitDelegate {

        initQuery(table: table)

        // Retrieves the 'ColumnDescriptors' that is used to describe the table
        let columns: [ColumnDescriptor] = DatabaseItem.getDescriptors(table: table as! DatabaseItem.Type)

        // The 'StringBuilder' that is to be used to hold the insertion query
        var queryStatement: String = "UPDATE \(String(describing: table)) SET "

        // Determines weather the string has had values amended to it
        var hasAppended: Bool = false

        // Stores the columns that will be skipped because they are auto generated
        var skipIndex: [ColumnDescriptor] = []

        var valueIndex: Int = 0;

        var whereClauses: String = "WHERE "

        // Appends the required values to the to the insertion statement
        columns.forEach({ (descriptor: ColumnDescriptor) in

            if (descriptor.isAuto) {

                whereClauses += "\(descriptor.name) = \(values[valueIndex]!)"

                skipIndex.append(descriptor)
                return
            }

            if (hasAppended) {

                queryStatement += ","
            }

            queryStatement += "\(descriptor.name) = ?"

            hasAppended = true
            valueIndex += 1;
        })

        queryStatement = "\(queryStatement) \(whereClauses)"

        var queryReference: OpaquePointer? = nil

        // Opens a connection the the SQLite database
        openConnection()

        var initDescriptors: Dictionary<ColumnDescriptor, Any> = Dictionary()

        // Setup object that will handle data transfer
        if sqlite3_prepare_v2(databaseReference, queryStatement, -1, &queryReference, nil) == SQLITE_OK {

            // Binds the required fields using the 'ColumnDescriptor'
            columns.forEach({ (descriptor: ColumnDescriptor) in

                // Retrieves the index of the column, using reverse lookup
                let columnIndex: Int = columns.firstIndex(of: descriptor)!

                // Skips if the column is auto generated
                if (skipIndex.firstIndex(of: descriptor) != nil) {

                    return
                }
                let columnIndex32: Int32 = Int32(columnIndex)

                initDescriptors[descriptor] = values[columnIndex]

                switch (descriptor.type) {

                case .text:

                    sqlite3_bind_text(queryReference, columnIndex32, (values[columnIndex] as! NSString).utf8String, -1, nil)
                    break

                case .integer:

                    sqlite3_bind_int(queryReference, columnIndex32, Int32(values[columnIndex] as! Int))
                    break
                }
            });

            // Places the values into the table using the insertion query
            sqlite3_step(queryReference)

            //Clean up
            sqlite3_finalize(queryReference)
        }

        closeConnection()

        return table.initWithColumnDescriptors(columns: initDescriptors) as! InitDelegate
    }

    /**
     * Inserts a new row into a table, with the specified values
     * - Parameters:
     *      - table: The table in question that will be queried
     *      - values: The The values that is required to be inserted into the database, minus the auto generated fields
    */
    public func queryDelete(table: InitDelegate.Type, id: Any) {

        initQuery(table: table)

        // Retrieves the 'ColumnDescriptors' that is used to describe the table
        let columns: [ColumnDescriptor] = DatabaseItem.getDescriptors(table: table as! DatabaseItem.Type)

        // The 'StringBuilder' that is to be used to hold the insertion query
        var queryStatement: String = "DELETE FROM \(String(describing: table)) WHERE id = ?"

        var queryReference: OpaquePointer? = nil

        // Opens a connection the the SQLite database
        openConnection()

        // Setup object that will handle data transfer
        if sqlite3_prepare_v2(databaseReference, queryStatement, -1, &queryReference, nil) == SQLITE_OK {

            // Binds the required fields using the 'ColumnDescriptor'
            columns.forEach({ (descriptor: ColumnDescriptor) in

                // Skips if the column is auto generated
                if (descriptor.name != "ID") {

                    return
                }

                switch (descriptor.type) {

                case .text:

                    sqlite3_bind_text(queryReference, 1, (id as! NSString).utf8String, -1, nil)
                    break

                case .integer:

                    sqlite3_bind_int(queryReference, 1, Int32(id as! Int))
                    break
                }
            });

            // Places the values into the table using the insertion query
            sqlite3_step(queryReference)

            //Clean up
            sqlite3_finalize(queryReference)
        }

        closeConnection()
    }
}
