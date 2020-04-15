//
//  ChatViewController.swift
//  final
//
//  Created by Xcode User on 2020-04-11.
//

import UIKit
import MessageKit

var chatService: ChatService!


class ChatViewController: MessagesViewController {

    var username : String = ""
    
    var messages: [Message] = []
    var member: Member!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hardcoded username and color
        member = Member(name: username, color: UIColor.random)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        chatService = ChatService(member: member, onReceivedMessage: {
            [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
        
        chatService.connect()
    }
}

extension ChatViewController: MessagesDataSource{
    
    
    func currentSender() -> SenderType {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    func messageTopLabelHeight(for message: MessageType
        , at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName,
                                  attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
    
}

extension ChatViewController: MessagesLayoutDelegate{
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}


extension ChatViewController: MessagesDisplayDelegate{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension ChatViewController: MessageInputBarDelegate{
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        chatService.sendMessage(text)
        inputBar.inputTextView.text = ""
    }
}

