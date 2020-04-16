/*
 
 Heon Lee
 991280638
 
 A view controller to take usernames from users
 2020-04-19
 */

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet var tfusername : UITextField!
    
    //Global variable
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
