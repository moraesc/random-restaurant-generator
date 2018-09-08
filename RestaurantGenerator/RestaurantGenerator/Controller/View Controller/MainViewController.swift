//
//  MainController.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 7/26/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var generateButton: GenerateButton!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var searchLocationView: SearchLocationView!
    @IBOutlet weak var selectMealTypeView: SelectMealTypeView!
    @IBOutlet weak var selectPriceView: SelectPriceView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var mapViewController: MapViewController?
    
    var selectedAddress: String?
    var currentAddress: String?
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "MapVCSegueID", sender: nil)
    }
    
    @IBAction func generateButton(_ sender: Any) {
        if selectedAddress == nil || selectMealTypeView.cuisineButtonValue == nil || selectPriceView.priceButtonValue == nil {
            let alert = UIAlertView()
            alert.title = "Please select a location, cuisine and price range."
            alert.addButton(withTitle: "OK")
            alert.show()
        } else {
            performSegue(withIdentifier: "RandomRestaurantsSegueID", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = #imageLiteral(resourceName: "Background")
        generateButton.setTitle("Generate", for: .normal)
        
        if selectedAddress != nil {
            searchLocationView.addressLabel.text = selectedAddress
            addLocationButton.setTitle("Edit location", for: .normal)
            searchLocationView.isHidden = false
        } else {
            searchLocationView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RandomRestaurantsSegueID" {
            if let nextVC = segue.destination as? RandomRestaurantViewController {
                nextVC.latitude = selectedLatitude
                nextVC.longitude = selectedLongitude
                nextVC.selectedCuisine = selectMealTypeView.cuisineButtonValue
                nextVC.selectedPrice = selectPriceView.priceButtonValue
            }
        }
    }
    
}
