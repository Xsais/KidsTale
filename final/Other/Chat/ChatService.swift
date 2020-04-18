/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: ChatService.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: This is a service class which connects to Scaledrone, access a channel in
 * Scaledrone, and publish rooms
 * ----------------------------------------------------------------------------+
*/

import Foundation
import Scaledrone

class ChatService {

    /**
     * The instance of Scaledrone that will be used to send and receive messages
    */
    private let scaledrone: Scaledrone
    
    /**
     * The callback that is to be used when a message is received
    */
    private let messageCallback: (Message)-> Void
    
    /**
     * Stores a copy of the applications delegate
    */
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**
     * Scaledrone Chat Room object
    */
    private var room: ScaledroneRoom?
    
    /**
     * Stores the default name of the room that the user is subscribed to
    */
    private var chatName : String = "observable-room1"

    /**
     * Takes the current Member class object
     * as well as a new message
     * - Parameters:
     *      - member: The object that initialized the event
     *      - onReceivedMessage: The callback that is to be used when a message is recieved
    */
    public init(member: Member, onReceivedMessage: @escaping (Message)-> Void){
        self.messageCallback = onReceivedMessage
        //Instantiate Scaledrone class object
        //Scaledrone class manages the connection to the Scaledrone
        //server / service
        self.scaledrone = Scaledrone(channelID: "MRDzzLaIQBsenZYU", data: member.toJSON)
        scaledrone.delegate = self as! ScaledroneDelegate
    }

    /**
     * Convert a chat name into a room name
     * - Parameters:
     *      - chatName: The desired name of the chat room
    */
    public func setChatName(chatName : String){
        
        if(chatName == "Administrator Chat"){
            self.chatName = "observable-room1"
        } else if (chatName == "Discussion Chat") {
            self.chatName = "observable-room2"
        } else {
            self.chatName = "observable-room3"
        }
    }

    /**
     * Convert a room name into a chat name
     * - Parameters:
     *      - chatName: The valid desired room name
    */
    func convertChatName(name : String) -> String{
        
        var chatName : String = ""
        
        if(name == "observable-room1"){
            chatName = "Administrator Chat"
        } else if (name == "observable-room2") {
            chatName = "Discussion Chat"
        } else {
            chatName = "General Chat"
        }
        
        return chatName
    }

    /**
     * Connect to the service
    */
    public func connect(){
        scaledrone.connect()
    }

    /**
     * Disconnect to the service
    */
    public func disconnect(){
        scaledrone.disconnect()
    }

    /**
     * Publish the new message
     * - Parameters:
     *      - message: The message that is desired to be published
    */
    public func sendMessage(_ message: String){
        room?.publish(message: message)
    }

    /**
     * Publish the new message
     * - Parameters:
     *      - message: The message that is desired to be published
    */
    public func publishNewMessages(){
        
        for message in mainDelegate.newMessages {
            messageCallback(message)
        }
        
        //Reset the count
        mainDelegate.notificationCount = 0
        
        //Empty new messages array
        mainDelegate.newMessages.removeAll()
        
    }

    /**
     * Retrieves the name of the current chat
    */
    func getChatName() -> String{
        return chatName
    }
}

 /**
  * A extension of the ChatService class, to handle manage chat rooms
 */
extension ChatService: ScaledroneDelegate{

    /**
     * Occurs when the Scaledrone instance receives an error
    */
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone error", error ?? "")
    }
    
    /**
     * Occurs when the Scaledrone instance disconnects
    */
    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone disconnected", error ?? "")
    }
    
    /**
     * Occurs when the Scaledrone instance connects
    */
    func scaledroneDidConnect(scaledrone: Scaledrone, error: Error?) {
        print("Connected to Scaledrone")
        //Prefix "Observable" required to contain the info of the sender in messages
        //Different room name - different chat sessions
        room = scaledrone.subscribe(roomName: chatName)
        room?.delegate = self as! ScaledroneRoomDelegate
    }
}

/**
 * A extension of the ChatService class, ScaledroneRoomDelegate allows the app to listen
 * to new incoming messages
 */
extension ChatService: ScaledroneRoomDelegate {
    
    /**
     * Occurs when the Scaledrone instance connects to a room
    */
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: Error?) {
        print("Connected to room!")
        
        //Initialize and set global variables
        mainDelegate.inChat = true
        mainDelegate.notificationCount = 0
    }
    
    /**
     * Occurs when the Scaledrone instance receives a message
    */
    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: Any, member: ScaledroneMember?) {
        guard
            let text = message as? String,
            let memberData = member?.clientData,
            let member = Member(fromJSON: memberData)
            else{
                print("Could not parse data.")
                return
        }
        
        let message = Message(member: member, text: text, messageId: UUID().uuidString)
        
        if(!mainDelegate.inChat!){
            //Increase the notification count by 1
            mainDelegate.notificationCount += 1
            mainDelegate.newMessages.append(message)
        } else {
            messageCallback(message)
        }
    }
}

