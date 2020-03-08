/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: VisibilityState.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Last Modified: 03-08-2020
 * Description: Stores the possible visibility states oof a UI Element
 * ----------------------------------------------------------------------------+
*/

import Foundation

public enum VisibilityState: Int {

    case visible = 1
    case hidden = 0
    case gone = -1
}
