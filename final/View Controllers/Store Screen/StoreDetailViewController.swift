/*
 Author : Jie Ming Wu  Created on 2020-04-05.
 Class  :  StoreDetailViewController.swift
 Project: IOSFinalProjectStoreDetails
 Copyright © 2020 Xcode User. All rights reserved.
*/
import UIKit

class StoreDetailViewController: UIViewController {

    //define Action OutLet variables for tags
    @IBOutlet var storeImage : UIImageView!
    @IBOutlet var storeDescription : UILabel!
    @IBOutlet var mapIcon : UIImageView!
    @IBOutlet var mapDestination : UILabel!
    @IBOutlet var mapOrigination : UITextField!
    @IBOutlet var directionBtn : UIButton!
    @IBOutlet var storeHour : UILabel!
    @IBOutlet var storeName : UILabel!
    @IBOutlet var locationChoise : UISwitch!
    @IBOutlet var locationTag : UILabel!
    @IBOutlet var locationFormat : UILabel!
    
   //define variable
    var mapIconString : String!
    var storeImageString : String!
    var storeDetail : Store!
    
    //define the AppDelegate object in order to get the resource form AppDelegate
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate 
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //pull out what store did the user select from AppDelegate
        //pull out the store details by comparing the stores data array to the
        for store in mainDelegate.storeData{
            if store.name == mainDelegate.storeSelect{
                
                //get store detail
                storeDetail = store
            }
        }
        
        //assign variable to the page by getting values from the store details selected by user
        mapIconString = "MapIcon2"
        mapIcon.image = UIImage(named: mapIconString)
        storeImageString = storeDetail.image
        storeImage.image = UIImage(named:  storeDetail.image!)
        storeHour.text = storeDetail.hours
        mapDestination.text =  storeDetail.location
        storeName.text =   storeDetail.name
        storeDescription.text =  storeDetail.description
        
        //save the store location into the object created in AppDelegate
        mainDelegate.storeLocation = storeDetail.location
    }
    
    //function to store the Input Location into AppDelegate
    @IBAction func GetDirection(sender: Any){
        mainDelegate.InputLocation = mapOrigination.text
    }
    
    //function to reset the Location Choise's value(switch value) in AppDelegate
    @IBAction func switchLocationValueChanged(sender: UISwitch){
        
        //check if switch value is ON or OFF
        if locationChoise.isOn{
            
            //show location tag to user when switch value is change
            locationTag.text = "Use Input Location"
            mapOrigination.isHidden = false
            locationFormat.isHidden = false
            
            //store the location to Appdelegate
            mainDelegate.LocationChoise = "ON"
        }
        else{
            
            //show location value to user when switch value is change
            locationTag.text = "Use My GPS Location"
            mapOrigination.isHidden = true
            locationFormat.isHidden = true
            
            //clear the text 
             mapOrigination.text = ""
            
            //store the lcoation choise to appdelegate
            mainDelegate.LocationChoise = "OFF"
        }
    }
    //function to redirect the page to previous page 
    @IBAction func unwindToStoreDetailViewController(sender :
        UIStoryboardSegue)
    {
    }

}
