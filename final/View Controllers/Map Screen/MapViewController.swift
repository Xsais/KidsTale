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

    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var DestinationAddress: UITextField!
    @IBOutlet weak var OriginalAddress: UITextField!
    @IBOutlet weak var MapIcon: UIImageView!
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var OriAddressString : String!
    var DesAddressString : String!
  
    override func viewDidLoad() {
        super.viewDidLoad()
 
         //define store address
        DesAddressString = "1310 trafalgar rd, Oakville"
        
        //get user authorizatoion for location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapview.delegate = self
    }
    
    @IBAction func getDirectionsTapped(sender: Any)
    {
        getAddress()
    }
  
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
            self.mapThis(destinationCord: location.coordinate)
        }

    }
//43.4675   79.6877
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D){
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    
}




