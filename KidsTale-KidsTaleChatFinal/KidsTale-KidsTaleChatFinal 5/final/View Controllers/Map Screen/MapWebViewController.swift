//
//  MapWebViewController.swift
//  final
//
//  Created by Xcode User on 2020-04-14.
//

import UIKit
import WebKit

class MapWebViewController: UIViewController {

    //define wkwebview object
    @IBOutlet var wbPage: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //set url to google map and show it to the user
        let urlAddress = URL(string: "https://www.google.com/maps/")
        let url = URLRequest(url: urlAddress!)
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
