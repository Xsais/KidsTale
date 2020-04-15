/*
 
 Heon Lee
 991280638
 
 Message.swift
 2020-04-19
 */

import Foundation
import UIKit
import MessageKit

//Chat Member
struct Member {
    let name: String
    let color: UIColor
}

//Chat Message
struct Message {
    let member: Member
    let text: String
    let messageId: String
}

//MessageKit works with MessageType protocols
extension Message: MessageType{
    var sender: SenderType {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}


//Converts between a JSON dictionary and Member class
extension Member {
    //Scaledrone Member class takes name and color in JSON format
    //Converts Member class into JSON Data
    var toJSON: Any {
        return [
            "name" : name,
            "color": color.hexString
        ]
    }
    
    //Get JSON data and create a member class
    init?(fromJSON json: Any){
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
