/*
 
 Heon Lee
 991280638
 
 ChatService.swift
 
 This is a service class which connects to Scaledrone, access a channel in
 Scaledrone, and publish rooms
 */

import Foundation
import Scaledrone

class ChatService {
    //Variables
    private let scaledrone: Scaledrone
    private let messageCallback: (Message)-> Void
    
    //Scaledrone Chat Room object
    private var room: ScaledroneRoom?
    
    private var chatName : String = "observable-room1"
    
    //Takes the current Member class object
    //as well as a new message
    init(member: Member, onReceivedMessage: @escaping (Message)-> Void){
        self.messageCallback = onReceivedMessage
        //Instantiate Scaledrone class object
        //Scaledrone class manages the connection to the Scaledrone
        //server / service
        self.scaledrone = Scaledrone(channelID: "MRDzzLaIQBsenZYU", data: member.toJSON)
        scaledrone.delegate = self as! ScaledroneDelegate
    }
    
    func setChatName(chatName : String){
        
        if(chatName == "Administrator Chat"){
            self.chatName = "observable-room1"
        } else if (chatName == "Discussion Chat") {
            self.chatName = "observable-room2"
        } else {
            self.chatName = "observable-room3"
        }
    }
    //Connect to the service
    func connect(){
        scaledrone.connect()
    }
    
    //Publish the new message
    func sendMessage(_ message: String){
        room?.publish(message: message)
    }
}

//A function to manage chat rooms.
extension ChatService: ScaledroneDelegate{
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone error", error ?? "")
    }
    
    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: Error?) {
        print("Scaledrone disconnected", error ?? "")
    }
    
    func scaledroneDidConnect(scaledrone: Scaledrone, error: Error?) {
        print("Connected to Scaledrone")
        //Prefix "Observable" required to contain the info of the sender in messages
        //Different room name - different chat sessions
        room = scaledrone.subscribe(roomName: chatName)
        room?.delegate = self as! ScaledroneRoomDelegate
    }
}

//ScaledroneRoomDelegate allows the app to listen
//to new incoming messages
extension ChatService: ScaledroneRoomDelegate {
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: Error?) {
        print("Connected to room!")
    }
    
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
        messageCallback(message)
    }
}


