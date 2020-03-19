/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: InitDelegate.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-09-2020
 * Last Modified: 03-19-2020
 * Description: Allows the creation of an object from an enumeration of 'ColumnDescriptor' and their values
 * ----------------------------------------------------------------------------+
*/

import Foundation

public protocol InitDelegate {

    /**
     * The place were all of the 'ColumnDescriptors' are registered
    */
    static func initDescriptors()

    /**
     * Allows the creation of an object from a table query look-up
     * - Parameters:
     *      - columns: The table columns that the object properties will be initialized with
    */
    static func initWithColumnDescriptors(columns: Dictionary<ColumnDescriptor, Any>) -> DatabaseItem
}
