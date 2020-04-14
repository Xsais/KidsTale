//
//  MapViewController.swift
//  IOSFinalProjectStoreDetails
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

// define action variable
    @IBOutlet weak var mapview: MKMapView!
   // @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var DestinationAddress: UILabel!
    //@IBOutlet weak var OriginalAddress: UITextField!
    @IBOutlet weak var MapIcon: UIImageView!
    
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
        
        //define store address
        DesAddressString =  DestinationAddress.text!
        
        //get user input location
        OriginalString = mainDelegate.InputLocation!
        LocationChoise = mainDelegate.LocationChoise
        
        //provide direction to user by location choise
        //if location choise is off, navigate user via user's GPS locaiton
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
          // if locaiton choise is ON, navigate user via user's input location
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
 //   @IBAction func getDirectionsTapped(sender: Any)
  //  {
      //  getAddress()
   // }
  
//get address geocode info
    func getAddress(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(DesAddressString) { (placemarks, error)
            in
            guard let placemarks = placemarks, let location =
            placemarks.first?.location
                else{
                    print("no location found")
                    return
            }
            print(location)
            
            //show the map to the user
            if self.LocationChoise == "OFF"
            {
                self.mapThisGPSLocation(destinationCord: location.coordinate)
            }
            else
            {
                   self.mapThisInputLocation(destinationCord: location.coordinate)
            }
         
        }
    }
    
//function to get geocode
    func getGeocode(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(OriginalString) { (placemarks, error)
            in
            guard let placemarks = placemarks, let location =
                placemarks.first?.location
                else{
                    print("no location found")
                    return
            }
            self.OriginalAddressString = location.coordinate
            print(location)
        }
        
    }
//oakville longitude latitude 43.4675   79.6877
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func mapThisGPSLocation(destinationCord : CLLocationCoordinate2D)
    {
         let souceCordinate = (locationManager.location?.coordinate)!
        
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
        let destPalceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPalceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else{
                if let error = error{
                    print("something is wrong")
                }
                return
            }
            let route = response.routes[0]
            self.mapview.addOverlay(route.polyline)
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func mapThisInputLocation(destinationCord : CLLocationCoordinate2D)
    {
       // let souceCordinate = (locationManager.location?.coordinate)!
        
        let soucePlaceMark = MKPlacemark(coordinate: OriginalAddressString!)//souceCordinate)
        let destPalceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPalceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else{
                if let error = error{
                    print("something is wrong")
                }
                return
            }
              let route = response.routes[0]
            self.mapview.addOverlay(route.polyline)
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    
}




