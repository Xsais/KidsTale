/*
 Author : Jie Ming Wu  Created on 2020-04-12.
 Class  :  MapWebViewController.swift
 Project: IOSFinalProjectStoreDetails - Map web View
 Copyright © 2020 Xcode User. All rights reserved.
 */

import UIKit
import WebKit

class MapWebViewController: UIViewController {
 
       //define wkwebview object
       @IBOutlet var wbPage : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set url to google map and show it to the user
        let urlAddress = URL(string: "https://www.google.com/maps/")
        let url = URLRequest(url: urlAddress!)
        wbPage?.load(url)
    }
}

