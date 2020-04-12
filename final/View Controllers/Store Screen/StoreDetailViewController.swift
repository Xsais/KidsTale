//
//  StoreDetailViewController.swift
//  IOSFinalProjectStoreDetails
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {

    @IBOutlet var storeImage : UIImageView!
    @IBOutlet var storeAddress : UITextView?
    @IBOutlet var storeDescription : UITextView?
    @IBOutlet var mapIcon : UIImageView!
    @IBOutlet var mapDestination : UITextField!
    @IBOutlet var mapOrigination : UITextField!
    @IBOutlet var directionBtn : UIButton!
    @IBOutlet var storeHour : UILabel!
    @IBOutlet var storeName : UILabel!
    
    
    var mapIconString : String!      //
    var storeImageString : String!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapIconString = "MapIcon2"
        mapIcon.image = UIImage(named: mapIconString)
        //storeImageString = mainDelegate.storeData[0].StoreImageString
        storeImage.image = UIImage(named: mainDelegate.storeData[0].image!)
        storeHour!.text = mainDelegate.storeData[0].hours!
        storeName!.text = mainDelegate.storeData[0].name!
        storeDescription?.text = mainDelegate.storeData[0].description!
        storeAddress?.text = mapIconString //mainDelegate.storeData[0].StoreLocationString!
        
    }
    

    @IBAction func unwindToStoreDetailViewController(sender :
        UIStoryboardSegue){
        
    }

}
