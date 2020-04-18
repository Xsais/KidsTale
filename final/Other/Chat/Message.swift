/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: Message.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: The backing object for a message, Chat Member
 * ----------------------------------------------------------------------------+
*/

import Foundation
import UIKit
import MessageKit

struct Member {
    
    /**
     * Stores the name
    */
    let name: String
    
    /**
     * Stores the color
    */
    let color: UIColor
}

/**
 * Chat Message
*/
struct Message {
    
    /**
     * The member that associated with the message
    */
    let member: Member
    
    /**
     * Stores the actual text of the message
    */
    let text: String
    
    /**
     * Stores the id of the message
    */
    let messageId: String
}

/**
 * An extension to the message class, MessageKit works with MessageType protocols
*/
extension Message: MessageType {
    
    /**
     * The sender of the message
    */
    var sender: SenderType {
        return Sender(id: member.name, displayName: member.name)
    }
    
    /**
     * The timestamp of the message
    */
    var sentDate: Date {
        return Date()
    }
    
    /**
     * The type of the message
    */
    var kind: MessageKind {
        return .text(text)
    }
}

/**
 * An extension to the message class, Converts between a JSON dictionary and Member class
*/
extension Member {
    
    /**
     * Scaledrone Member class takes name and color in JSON format
     * Converts Member class into JSON Data
    */
    var toJSON: Any {
        return [
            "name": name,
            "color": color.hexString
        ]
    }
    
    /**
     * Get JSON data and create a member class
    */
   public init?(fromJSON json: Any) {
        guard
                let data = json as? [String: Any],
                let name = data["name"] as? String,
                let hexColor = data["color"] as? String
                else {
            print("Couldn't parse Member")
            return nil
        }

        self.name = name
        self.color = UIColor(hex: hexColor)
    }
}
