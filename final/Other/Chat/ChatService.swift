//
//  ChatService.swift
//  FinalProject_Test
//
//  Created by Xcode User on 2020-03-17.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation
import Scaledrone

class ChatService {
    private let scaledrone: Scaledrone
    private let messageCallback: (Message)-> Void
    
    private var room: ScaledroneRoom?
    
    init(member: Member, onReceivedMessage: @escaping (Message)-> Void){
        self.messageCallback = onReceivedMessage
        self.scaledrone = Scaledrone(channelID: "MRDzzLaIQBsenZYU", data: member.toJSON)
        scaledrone.delegate = self as! ScaledroneDelegate
    }
    
    func connect(){
        scaledrone.connect()
    }
    
    func sendMessage(_ message: String){
        room?.publish(message: message)
    }
}

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
        room = scaledrone.subscribe(roomName: "observable-room")
        room?.delegate = self as! ScaledroneRoomDelegate
    }
}

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


