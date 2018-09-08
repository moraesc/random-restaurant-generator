//
//  MapVC.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 8/3/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAddress: String?
    var latitude: Double?
    var longitude: Double?
    
    @IBAction func nextButton(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.selectedAddress = selectedPin?.title
        vc.selectedLatitude = latitude
        vc.selectedLongitude = longitude
        
        present(vc, animated: true, completion: nil)
        
    }
    
    //object that will give you GPS coordinates
    var locationMngr = CLLocationManager()
    var selectedPin: MKPlacemark? = nil
    var resultSearchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        setupSearchTable()
        setupSearchBar()
                
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        //limits the overlap area overlap area to just the VC frame instead of the whole Nav controller
        definesPresentationContext = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupSearchTable() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
    
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    func setupSearchBar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter your location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.titleView = resultSearchController?.searchBar
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationMngr.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enabled Location Services in Settings", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            return
        default:
            break
        }
        
        locationMngr.delegate = self
        locationMngr.desiredAccuracy = kCLLocationAccuracyBest
        locationMngr.requestLocation()
        
    }
    
    //called when location information comes back - you get an array of locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            //zoom to users current location
            //arbitrary area of 0.05 degrees longitude and 0.05 degree latitude
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            //map center (coorindate) and zoom level (span)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: ", error)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationMngr.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
            
            print("last location: ", lastLocation)
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        //cache the pin
        selectedPin = placemark
        
        selectedAddress = selectedPin?.title
        
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        latitude = annotation.coordinate.latitude
        longitude = annotation.coordinate.longitude
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}
