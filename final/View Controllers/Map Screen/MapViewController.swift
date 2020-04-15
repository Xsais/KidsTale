/*
 Author : Jie Ming Wu  Created on 2020-04-05.
 Class  :  MapViewController.swift
 Project: IOSFinalProjectStoreDetails - Map View
 Copyright © 2020 Xcode User. All rights reserved.
 */

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

// define action variables
    
    @IBOutlet weak var mapview: MKMapView!
   // @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var DestinationAddress: UILabel!
    //@IBOutlet weak var OriginalAddress: UITextField!
    @IBOutlet weak var MapIcon: UIImageView!
    
//define local variables
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var OriAddressString : String!
    var DesAddressString : String!
    var OriginalAddressString : CLLocationCoordinate2D!
    var OriginalString : String!
    var LocationChoise : String!
    
//define the AppDelegate object as to get the AppDelegate data
  let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign destination address value
        DestinationAddress.text = mainDelegate.storeLocation!
        
        //define and get store address
        DesAddressString =  DestinationAddress.text!
        
        //get user input location
        OriginalString = mainDelegate.InputLocation!
        LocationChoise = mainDelegate.LocationChoise
        
        //provide direction to user by location choise
        //if location choise is off, navigate user via user's GPS locaiton
        //by calling the GPS function
        if mainDelegate.LocationChoise == "OFF"
        {
           
            //get user authorizatoion for location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapview.delegate = self
            getAddress()
        }
          // if locaiton choise is ON, navigate user by using user's input location
        else
        {
            //get user authorizatoion for location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapview.delegate = self
            getGeocode()
            getAddress()
        }
    }

  
//function to get address direction
    func getAddress(){
        
        //define Geocoder variable
        let geoCoder = CLGeocoder()
        
        //call geocode address servise and get the destination address
        geoCoder.geocodeAddressString(DesAddressString) { (placemarks, error)
            in
            guard let placemarks = placemarks, let location =
            placemarks.first?.location
                //if the location is not exist, print out the error message
                else{
                    print("no location found")
                    return
            }
            print(location)
            
            //show the map to the user by user's location choise
            if self.LocationChoise == "OFF"
            {
                //show user direction by using the user's GPS location
                self.mapThisGPSLocation(destinationCord: location.coordinate)
            }
            else
            {
                //show user direction by using the user input location
                   self.mapThisInputLocation(destinationCord: location.coordinate)
            }
         
        }
    }
    
//function to get geocode or convert address to geocode
    func getGeocode(){
        //define Geocoder variable
        let geoCoder = CLGeocoder()
        
        //check if user input location is exist or not by calling the map api server
        geoCoder.geocodeAddressString(OriginalString) { (placemarks, error)
            in
            guard let placemarks = placemarks, let location =
                placemarks.first?.location
                
                //print out the error message if the locaiton can not be found
                else{
                    print("no location found")
                    return
            }
            //store the Longitude and Latitude value
            self.OriginalAddressString = location.coordinate
            
            //print it out for testing purpose.
            print(location)
        }
        
    }
//oakville longitude latitude 43.4675   79.6877
 
    //function to update the user location by user's movement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    //function to map the location for user base on user's GPS location
    func mapThisGPSLocation(destinationCord : CLLocationCoordinate2D)
    {
        //define the location coordinate vale by using the locaitonManager
         let souceCordinate = (locationManager.location?.coordinate)!
        
        //define from location's geocode and to location's geocode
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
        let destPalceMark = MKPlacemark(coordinate: destinationCord)
        
        //assgin geocode value to the MKMapItem
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPalceMark)
        
        //create server request object and call it
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        //call the direction server request
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else{
                //if response with error, print out the error message for testing purpose
                if let error = error{
                    print("something is wrong")
                }
                return
            }
            //prepare the map view
            let route = response.routes[0]
            self.mapview.addOverlay(route.polyline)
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
     //function to map the location for user base on user's input location
    func mapThisInputLocation(destinationCord : CLLocationCoordinate2D)
    {
        //define from location's geocode and to location's geocode
        let soucePlaceMark = MKPlacemark(coordinate: OriginalAddressString!)//souceCordinate)
        let destPalceMark = MKPlacemark(coordinate: destinationCord)
        
             //assgin geocode value to the MKMapItem
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPalceMark)
        
          //create server request object and call it
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
    //create the direction request server as an object and call the direction server request
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else{
                if let error = error{
                    
    //if response with error, print out the error message for testing purpose
                    print("something is wrong")
                }
                return
            }
    //prepare the map view
              let route = response.routes[0]
            self.mapview.addOverlay(route.polyline)
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    //function to prepare the mapView
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    
    //function to redirect the page to the previous page
    @IBAction func unwindToStoreDetailViewController(sender :
        UIStoryboardSegue)
    {
    }
    
}




