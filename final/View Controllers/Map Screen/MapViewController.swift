/**
 * ----------------------------------------------------------------------------+
 * Created by: Jie Ming Wu
 * Filename: MapViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: The backing view controller for the map screen
 * ----------------------------------------------------------------------------+
*/

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    /**
     * The UIElement that stores the location of the map view
    */
    @IBOutlet weak var mapview: MKMapView!
    
    /**
     * The label that shows the destination address of the map
    */
    @IBOutlet weak var DestinationAddress: UILabel!
    
    /**
     * The icon that is displayed on the map page
    */
    @IBOutlet weak var MapIcon: UIImageView!
    
    /**
     * The object that manages the locations
    */
    let locationManager = CLLocationManager()
    
    /**
     * The current location to display on the map
    */
    var previousLocation: CLLocation?
    
    /**
     * Stores the originating address
    */
    var OriAddressString: String!
    
    /**
     * Stores the destination address
    */
    var DesAddressString: String!
    
    /**
     * Stores the coordinates the the originating address
    */
    var OriginalAddressString: CLLocationCoordinate2D!
    
    /**
     * Stores the string of the original address
    */
    var OriginalString: String!
    
    /**
     * Stores the choice for the location
    */
    var LocationChoise: String!
    
    /**
     * define the AppDelegate object as to get the AppDelegate data
    */
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        //assign destination address value
        DestinationAddress.text = mainDelegate.storeLocation!

        //define store address
        DesAddressString = DestinationAddress.text!

        //get user input location
        OriginalString = mainDelegate.InputLocation!
        LocationChoise = mainDelegate.LocationChoice

        //provide direction to user by location choice
        //if location choice is off, navigate user via user's GPS location
        if mainDelegate.LocationChoice == "OFF" {

            //get user authorization for location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapview.delegate = self
            getAddress()
        }
        // if location choice is ON, navigate user via user's input location
        else {
            //get user authorization for location
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

    /**
     * get address geocode info
    */
    func getAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(DesAddressString) { (placemarks, error)
        in
            guard let placemarks = placemarks, let location =
            placemarks.first?.location
                    else {
                print("no location found")
                return
            }
            print(location)

            //show the map to the user
            if self.LocationChoise == "OFF" {
                self.mapThisGPSLocation(destinationCord: location.coordinate)
            } else {
                self.mapThisInputLocation(destinationCord: location.coordinate)
            }

        }
    }

    /**
     * function to get geocode
    */
    func getGeocode() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(OriginalString) { (placemarks, error)
        in
            guard let placemarks = placemarks, let location =
            placemarks.first?.location
                    else {
                print("no location found")
                return
            }
            self.OriginalAddressString = location.coordinate
            print(location)
        }

    }

    /**
     * The callback for the location manager
      * - Parameters:
      *      - manager: The manager that is used to manage the location
      *      - locations: The valid locations
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    /**
     * Maps the current GPS coordinate
     * - Parameters:
     *      - destinationCord: The coordinates that is to be mapped
    */
    func mapThisGPSLocation(destinationCord: CLLocationCoordinate2D) {
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
            guard let response = response else {
                if let error = error {
                    print("something is wrong")
                }
                return
            }
            let route = response.routes[0]
            self.mapview.addOverlay(route.polyline)
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    /**
     * Maps the location that was imputed
     * - Parameters:
     *      - destinationCord: The coordinates that is to be mapped
    */
    func mapThisInputLocation(destinationCord: CLLocationCoordinate2D) {

        //souceCordinate)
        let soucePlaceMark = MKPlacemark(coordinate: OriginalAddressString!)
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
            guard let response = response else {
                if let error = error {
                    print("something is wrong")
                }
                return
            }
            let route = response.routes[0]
            self.mapview.addOverlay(route.polyline)
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    /**
     * Callback for when the map view is rendering
     * - Parameters:
     *      - mapView: The mapview that is rendering
     *      - overlay: The overlay for the map view
    */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }

    /**
     * Allows ViewController to perform an unwind segue
     * - Parameters:
     *      - sender: The object that initialized the event
    */
    @IBAction func unwindToMapViewController(sender:
            UIStoryboardSegue) {
    }

}




