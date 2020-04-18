/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: ChatListViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description:  A view controller to list available chat rooms
 * ----------------------------------------------------------------------------+
*/

import UIKit

class ChatListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     * Stores the user desired username
    */
    var username : String = ""
    
    /**
     * Stores all rooms the application handles
    */
    var rooms : Array<Room> = [Room]()
    
    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create sample rooms
        let adminRoom : Room = Room.init()
        adminRoom.initWithData(theName: "Administrator Chat", theAvailability: "Available", theImage: "nightsky_unsplash.jpeg")
        let chat1 : Room = Room.init()
        chat1.initWithData(theName: "General Chat", theAvailability: "Available", theImage: "above_the_clouds_the_sky-wide.jpg")
        
        let chat2 : Room = Room.init()
        chat2.initWithData(theName: "Discussion Chat", theAvailability: "Available", theImage: "Daniele-Bianchin-above-the-sky.png")
        
        rooms.append(adminRoom)
        rooms.append(chat1)
        rooms.append(chat2)
        
        
    }

    /**
     * Displays a guide to the user on how to use the chat system
      * - Parameters:
      *      - sender: The object that initiated the event
     */
    @IBAction func guide(sender : Any){
        let alert = UIAlertController(title: "Welcome to KidsTale Chat!", message: "1. Click the chat name to enter the chat" +
            "\n2. Swipe from the right to see the information of each chat", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /**
     * determines the total amount of element in the table view
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - numberOfRowsInSection: The number of rows in the selection
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    /**
     * Determines the height of each cell in the table
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - heightForRowAt: The height of the cell in the tableview
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    /**
     * Fills the TableView with UITableViewCells
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - cellForRowAt: The object that initialized the event
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserViewCell ?? UserViewCell(style: .default, reuseIdentifier: "cell")
        
        tableCell.primaryLabel.text = rooms[indexPath.row].name!
        
        tableCell.secondaryLabel.text = rooms[indexPath.row].availability!
        
        //Image for the room
        let img = UIImage(named: rooms[indexPath.row].image!)
        
        tableCell.myImageView.image = img
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    /**
     * Event that fires when a row is selected
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - didSelectRowAt: The indexpath of the selected row
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Programmatically redirect to ChatViewController
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatView") as! ChatViewController
        
        //Pass the username
        vc.username = self.username
        vc.chatName = rooms[indexPath.row].name!
        
        self.present(vc, animated: true, completion: nil)
    }

    /**
     * Event that when the user requests the options for a cell
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - editActionsForRowAt: The index path of the row that requested the options
    */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let notification = UITableViewRowAction(style: .normal, title: "What is this chat?") {
            (action, index) in
            
            var title : String = ""
            var alertMessage : String = ""
            
            if(self.rooms[indexPath.row].name! == "Discussion Chat"){
                title = "Discussion Chat"
                alertMessage = "You can discuss about stores"
                    + "or books in this chat!"
            } else if(self.rooms[indexPath.row].name! == "Administrator Chat"){
                
                title = "Administrator Chat"
                alertMessage = "Please ask administrators about any " +
                "questions regarding the app!"
            } else {
                
                title = "General Chat"
                alertMessage = "Chat with other KidsTale users!"
            }
            
            let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        notification.backgroundColor = UIColor(hex: "#3498db")
        
        return [notification]
    }
}
