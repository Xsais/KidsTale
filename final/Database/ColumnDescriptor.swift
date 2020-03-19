/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: ColumnDescriptor.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-09-2020
 * Last Modified: 03-19-2020
 * Description: Represents a single column within the SQLite database
 * ----------------------------------------------------------------------------+
*/

import Foundation

public class ColumnDescriptor: Hashable {

    /**
     * Allows the comparision of two 'ColumnDescriptor' object
     * - Parameters:
     *      - compare: The 'ColumnDescriptor' object that will be compared to
     *      - against: The 'ColumnDescriptor' object that will be compared against
    */
    public static func == (compare: ColumnDescriptor, against: ColumnDescriptor) -> Bool {

        return compare.name == against.name && compare.type == against.type
    }

    // Stores the name of the tables column
    private var _name: String

    // Stores the datatype of the tables column
    private let _type: DataType

    // Allows the retrieval of the name of the tables column
    public var name: String { get { return _name }}

    // Allows the retrieval of the datatype of the tables column
    public var type: DataType { get { return _type }}

    // Determines weather the field will be auto generated (NULL value)
    public let isAuto: Bool

    /**
    * Allows the creation of a 'ColumnDescriptor' that describes a column in a table
    * - Parameters:
    *      - isAuto: Will the field be auto generated (NULL value)
    *      - columnName: The name of the column asd it is in the database
    *      - columnType: The type of the column as it is in the database
    */
    public init(isAuto: Bool = false, columnName: String, columnType: DataType) {
        
        self.isAuto = isAuto
        
        self._name = columnName
        self._type = columnType
    }

    /**
    * Retrieves a hash value that represents the class
    * - Parameters:
    *      - hasher: The object that is used to generate the hash value
    */
    public func hash(into hasher: inout Hasher) {

        hasher.combine(name)
        hasher.combine(type)
    }
}
