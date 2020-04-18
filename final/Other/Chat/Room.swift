/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: Room.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: This is a data class for listing rooms
 * ----------------------------------------------------------------------------+
*/

import UIKit

class Room: NSObject {
    
    /**
     * Stores the name of the room
    */
    var name: String?
    
    /**
     * Stores the image of the room
    */
    var image: String?
    
    /**
     * Stores the availability of the room
    */
    var availability: String?

    /**
     * Takes the current Member class object
     * as well as a new message
     * - Parameters:
     *      - theName: The desired name of the room
     *      - theAvailability: The desired availability of the room
     *      - theImage: The desired image of the room
    */
    func initWithData(theName name: String, theAvailability available: String,
                      theImage image: String) {
        self.name = name
        self.image = image
        self.availability = available
    }
}
