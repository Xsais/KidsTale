/**
 * ----------------------------------------------------------------------------+
 * Created by: Jie Ming Wu
 * Filename: MapWebViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: The backing view controller for the map screen web page view
 * ----------------------------------------------------------------------------+
*/

import UIKit
import WebKit

class MapWebViewController: UIViewController {
    
    /**
     * The UIElement that stores the location of the map view
    */
    @IBOutlet var wbPage: WKWebView!
    
    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        //set url to google map and show it to the user
        let urlAddress = URL(string: "https://www.google.com/maps/")
        let url = URLRequest(url: urlAddress!)
        wbPage?.load(url)
    }
}
