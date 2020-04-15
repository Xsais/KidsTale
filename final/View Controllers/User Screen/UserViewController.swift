//
//  UserViewController.swift
//  final
//
//  Created by Xcode User on 2020-04-11.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet var tfusername : UITextField!
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func getUsername(sender : Any){
        
        let strUsername = tfusername.text!
        
        if (strUsername.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            username = strUsername
        }
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "UserListTableView") as! UserListTableViewController
        
        vc.username = self.username
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    

}
