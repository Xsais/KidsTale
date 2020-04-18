/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: ChatViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description:  The view controller that handles sending a recieving messages, Implementing MessagesViewController allows us to use
 * basic chat UI provided by MessageKit
 * ----------------------------------------------------------------------------+
*/

import UIKit
import MessageKit

var chatService: ChatService!

class ChatViewController: MessagesViewController {
    
    /**
     * Stores the user desired username
    */
    var username : String = ""
    
    /**
     * Stores the chat room name
    */
    var chatName : String = ""
    
    /**
     * define the AppDelegate object as to get the AppDelegate data
    */
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**
     * Stores the messages that have been sent and received
    */
    var messages: [Message] = []
    
    /**
     * Stores the current member of the chat
    */
    var member: Member!
    
    /**
     * An event that is fired when the view is loaded into memory
     *
     * - Reference:
     *     - https://stackoverflow.com/questions/53642355/uibarbuttonitem-doesnt-show-up-when-using-messagekit
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 45))
        
        navigationBar.items?.append(UINavigationItem(title: chatName))
        
        //Add back button
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        
        navigationBar.topItem?.leftBarButtonItem = backButton
        
        //Add Exit Button
        let exitButton = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exit))
        
        navigationBar.topItem?.leftBarButtonItem = backButton
        
        navigationBar.topItem?.rightBarButtonItem = exitButton
        
        self.view.addSubview(navigationBar)
        
        //Member
        //Username given by the user
        //Color is generated randomly.
        //Scaledrone supports Colors instead of images as profile pictures
        member = Member(name: username, color: UIColor.random)
        //Delegate and Datasource are set to self
        //ChatViewController extends to each datasource and delegate as well as
        //implementing the members
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)
        
        mainDelegate.inChat = true
        
        //If the user enters the same chat room as before
        if(mainDelegate.chatService == nil || mainDelegate.chatService!.getChatName() != self.chatName){
            
            //Instantiate a ChatService object
            //Pass the member object and the message object
            //Reload the data and the chat room after the message is uploaded
            //Focus to the recent message which will always be at the bottom
            //of the page
            mainDelegate.chatService = ChatService(member: member, onReceivedMessage: {
                [weak self] message in
                self?.messages.append(message)
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToBottom(animated: true)
            })
        }
        
        mainDelegate.chatService!.setChatName(chatName: chatName)
        
        //Connect the Chat Service
        mainDelegate.chatService!.connect()
        
        mainDelegate.chatService!.publishNewMessages()
    }

    /**
      * Performs a transition to the previous page
      * - Parameters:
      *      - sender: The buttonitem that was clicked
      *
      * - Reference:
      *     - https://github.com/MessageKit/MessageKit/issues/860
     */
    @objc func back(sender : UIBarButtonItem){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatListTableView") as! ChatListViewController
        
        self.present(vc, animated: true, completion: nil)
        
        //The user is not in the chat
        mainDelegate.inChat! = false
        //Initialize notification count
        mainDelegate.notificationCount = 0
    }

    /**
      * Exits and disconnects the chat features of the application
      * - Parameters:
      *      - sender: The buttonitem that was clicked
     */
    @objc func exit(sender : UIBarButtonItem){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatListTableView") as! ChatListViewController
        
        self.present(vc, animated: true, completion: nil)
        
        //Reset values
        mainDelegate.inChat = nil
        //Disconnect from the chat
        mainDelegate.chatService!.disconnect()
        //Remove the ChatService class object
        mainDelegate.chatService = nil
        //Initialize notification count
        mainDelegate.notificationCount = 0
        //Remove all new messages
        mainDelegate.newMessages.removeAll()
    }
}

/**
  * Number and content of messages
  * Number of messages means the order of the messages
 */
extension ChatViewController: MessagesDataSource {

    /**
      * Create a Sender object using the member
     */
    func currentSender() -> SenderType {
        return Sender(id: member.name, displayName: member.name)
    }

    /**
      * Return the message of a specific section index
      * - Parameters:
      *      - indexPath: The current index of the message
      *      - messagesCollectionView: The collection that stores all of the messages
     */
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    /**
      * Retrieves the number of messages
      * - Parameters:
      *      - messagesCollectionView: The collection that stores all of the messages
     */
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    /**
      * Assigns the top label height of the message, height between each messages
      * - Parameters:
      *      - message: The type of the message
      *      - indexPath: The current index of the message
      *      - messagesCollectionView: The collection that stores all of the messages
     */
    func messageTopLabelHeight(for message: MessageType
        , at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }

    /**
      * Retrevies the font that is to be used for the sender name
      * - Parameters:
      *      - message: The type of the message
      *      - indexPath: The current index of the message
     */
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName,
                                  attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
    
}

/**
  * Provides height, padding, and alignment of views
 */
extension ChatViewController: MessagesLayoutDelegate{

    /**
      * Retrieves the that each messages sub component shall have
      * - Parameters:
      *      - message: The type of the message
      *      - indexPath: The current index of the message
      *      - maxWidth: The maximum width of the message
      *      - messagesCollectionView: The collection that stores all of the messages
     */
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

/**
  * Defines the look of the message
 */
extension ChatViewController: MessagesDisplayDelegate {

    /**
      * Retrieves the avatar that is assigned for a specific message
      * - Parameters:
      *      - avatarView: The avatar that will be assigned to the message
      *      - message: The type of the message
      *      - indexPath: The current index of the message
      *      - messagesCollectionView: The collection that stores all of the messages
     */
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

/**
  * Manages sending and typing new messages
 */
extension ChatViewController: MessageInputBarDelegate {

    /**
      * Event that occurs when the input bar receives an event to send a message
      * - Parameters:
      *      - inputBar: The input bar that is responsible for the the event
      *      - didPressSendButtonWith: The text that is being requested to be sent
     */
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //chatService.sendMessage(text)
        mainDelegate.chatService!.sendMessage(text)
        //Empty string on the input bar by default
        inputBar.inputTextView.text = ""
    }
}

