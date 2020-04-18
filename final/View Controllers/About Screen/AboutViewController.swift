/**
 * ----------------------------------------------------------------------------+
 * Created by: Sher Khan
 * Filename: AboutViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-15-2020
 * Description: The view controller that handles the action of the about screen
 * ----------------------------------------------------------------------------+
*/

import UIKit
import WebKit

class AboutViewController: UIViewController {

    /**
     * Holds a copy of the webpage that is used to display the website
    */
    @IBOutlet var wbPage :WKWebView!

    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //url of git
        let urlGithubRepo =  URL(string: "https://www.github.com/Xsais/KidsTale")
        
        //request
        //load
        let url = URLRequest(url: urlGithubRepo!)
        wbPage?.load(url)
        
        
    }

}
