//
//  AboutViewController.swift
//  final
// Author- Sher Khan
//  Created by Xcode User on 2020-04-15.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    @IBOutlet var wbPage :WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //url of git
        let urlGithubRepo =  URL(string: "https://www.github.com/Xsais/KidsTale")
        
        //request
        //load
        let url = URLRequest(url: urlGithubRepo!)
        wbPage?.load(url)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
