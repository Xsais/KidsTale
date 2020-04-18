/**
 * ----------------------------------------------------------------------------+
 * Created by: Jie Ming Wu
 * Filename: StoreDetailViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: The backing view controller for the store details screen
 * ----------------------------------------------------------------------------+
*/

import UIKit

class StoreDetailViewController: SmartUIViewController {

    /**
     * Stores the image that is displayed for the store
    */
    @IBOutlet var storeImage: UIImageView!

    /**
     * Stores the description of the store
    */
    @IBOutlet var storeDescription: UILabel!

    /**
     * Stores the map icon that is used for the store
    */
    @IBOutlet var mapIcon: UIImageView!

    /**
     * Stores the map destination for the store
    */
    @IBOutlet var mapDestination: UILabel!

    /**
     * Stores the originating location for the store
    */
    @IBOutlet var mapOrigination: UITextField!

    /**
     * Stores the direction button on the store screen
    */
    @IBOutlet var directionBtn: UIButton!

    /**
     * Stores the label that display the operating hours of the store
    */
    @IBOutlet var storeHour: UILabel!

    /**
     * Stores the label that stores the name of the store
    */
    @IBOutlet var storeName: UILabel!

    /**
     * Stores the switch that determines the location choice for the store
    */
    @IBOutlet var locationChoise: UISwitch!

    /**
     * Stores the the label that determines the tag for the store
    */
    @IBOutlet var locationTag: UILabel!

    /**
     * Stores the the label that displays the formatted location for the store
    */
    @IBOutlet var locationFormat: UILabel!

    /**
     * Stores the string to determine the mapicon that is to be used
    */
    var mapIconString: String!

    /**
     * Stores the string to determine the image of the store that is to be used
    */
    var storeImageString: String!

    /**
     * Stores store object that is to be used
    */
    var storeDetail: Store!

    /**
     * define the AppDelegate object in order to get the resource form AppDelegate
    */
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        //pull out what store did the user select
        storeDetail = (mainDelegate.selectedItem as! Store)

        //assign variable to the page by getting values from the store details selected by user
        mapIconString = "MapIcon2"
        mapIcon.image = UIImage(named: mapIconString)
        storeImageString = storeDetail.image
        storeImage.image = UIImage(named: storeDetail.image!)
        storeHour.text = storeDetail.hours
        mapDestination.text = storeDetail.location
        storeName.text = storeDetail.name
        storeDescription.text = storeDetail.description

        //save the store location into the object created in AppDelegate
        mainDelegate.storeLocation = storeDetail.location
    }

    /**
     * Assigns the direction
     * - Parameters:
     *      - sender: The object that initialized the event
    */
    @IBAction func GetDirection(sender: Any) {
        mainDelegate.InputLocation = mapOrigination.text
    }

    /**
     * Event to determine if the location of the map should be pulled from the GPS
     * - Parameters:
     *      - sender: Theo switch that is responsible for the event
    */
    @IBAction func switchLocationValueChanged(sender: UISwitch) {
        if locationChoise.isOn {
            //show location tag to user when switch value is change
            locationTag.text = "Use Input Location"
            mapOrigination.isHidden = false
            locationFormat.isHidden = false
            //store the location to Appdelegate
            mainDelegate.LocationChoice = "ON"
        } else {
            //show location value to user when switch value is change
            locationTag.text = "Use My GPS Location"
            mapOrigination.isHidden = true
            locationFormat.isHidden = true
            //clear the text 
            mapOrigination.text = ""
            //store the lcoation choise to appdelegate
            mainDelegate.LocationChoice = "OFF"
        }
    }

    /**
     * Allows ViewController to perform an unwind segue
     * - Parameters:
     *      - sender: The object that initialized the event
    */
    @IBAction func unwindToStoreDetailViewController(sender: UIStoryboardSegue) {
    }
}
