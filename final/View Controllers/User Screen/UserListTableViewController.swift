//
//  UserListTableViewController.swift
//  final
//
//  Created by Xcode User on 2020-04-11.
//

import UIKit

class UserListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserViewCell ?? UserViewCell(style: .default, reuseIdentifier: "cell")
        
        tableCell.primaryLabel.text = "User 1"
        
        tableCell.secondaryLabel.text = "Available"
        
        let img = UIImage(named: "above_the_clouds_the_sky-wide")
        
        tableCell.myImageView.image = img
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatView") as! ChatViewController
        
        vc.username = self.username
        
        self.present(vc, animated: true, completion: nil)
    }

}
