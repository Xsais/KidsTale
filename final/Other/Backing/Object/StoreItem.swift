/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: StoreItem.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-09-2020
 * Last Modified: 03-19-2020
 * Description: Allows polymorphism between the store items
 * ----------------------------------------------------------------------------+
*/

import Foundation

public protocol StoreItem: InitDelegate, DatabaseItem { }