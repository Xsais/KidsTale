/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: UserViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description:  A view controller to take usernames from users
 * ----------------------------------------------------------------------------+
*/

import UIKit

class UserViewController: UIViewController {
    
    /**
     * The entered username by the user
    */
    @IBOutlet var tfusername : UITextField!
    
    /**
     * define the AppDelegate object as to get the AppDelegate data
    */
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**
     * The username that is to be used
    */
    var username : String = ""
    
    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    /**
     * Retrieves the usernames that was entered by the user
      * - Parameters:
      *      - sender: The object that initiated the event
     */
    @IBAction func getUsername(sender : Any){
        
        let strUsername = tfusername.text!
        
        //If the username is empty
        if (strUsername.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            username = strUsername
        }
        
        //Programmatically redirect to the next view controller
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatListTableView") as! ChatListViewController
        
        //Pass the username to the UserListTableViewController
        vc.username = self.username
        
        //Save the username to the app delegate for the future use
        mainDelegate.username = self.username
        
        self.present(vc, animated: true, completion: nil)
    }
}
