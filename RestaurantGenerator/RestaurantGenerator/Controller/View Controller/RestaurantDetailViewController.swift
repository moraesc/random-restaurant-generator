//
//  RestaurantDetailVC.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 8/6/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDetails: UILabel!
    @IBOutlet weak var firstReviewView: UIView!
    @IBOutlet weak var firstReviewTextLabel: UILabel!
    @IBOutlet weak var secondReviewView: UIView!
    @IBOutlet weak var secondReviewTextLabel: UILabel!
    @IBOutlet weak var openMapButton: UIButton!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    var name: String?
    var details: String?
    var id: String?
    var review: String?
    var firstURL: String?
    var secondURL: String?
    var latitude: Double?
    var longitude: Double?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    lazy var starImageArray: [UIImageView] = {
       return [star1, star2, star3, star4, star5]
    }()
    
    @IBAction func seeMoreFirstReview(_ sender: Any) {
        performSegue(withIdentifier: "ShowReviewSegueID", sender: nil)
    }
    
    @IBAction func seeMoreSecondReview(_ sender: Any) {
        performSegue(withIdentifier: "ShowReviewSegueID", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReviewSegueID" {
            if let nextVC = segue.destination as? ReviewViewController {
                nextVC.reviewURL = firstURL
                nextVC.reviewURL = secondURL
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        fetchData()
        
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        
        openMapButton.addTarget(self, action: #selector(openLocationInMap), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func openLocationInMap() {
        let lat: CLLocationDegrees = latitude!
        let long: CLLocationDegrees = longitude!
        
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(lat, long)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurantName.text
        mapItem.openInMaps(launchOptions: options)
    }
    
    func setupVC() {
        restaurantName.text = name
        restaurantDetails.text = details
        
        firstReviewView.layer.cornerRadius = 15
        secondReviewView.layer.cornerRadius = 15
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        let idString = id ?? ""
        
        let myUrl = URL(string: "https://api.yelp.com/v3/businesses/\(idString)/reviews")

        var request = URLRequest(url: myUrl!)

        request.httpMethod = "GET"

        request.addValue("Bearer d1xavm5obDa94rhvD7ltfuFa1yFYrcQA1itMW0OJXjKUVgSLnAoZ9rndvnPWGmj87Dp1Urw8Um1QCaUoo_aBBK9tQfkV5Xr2cqqiIayw31nWYaz5TfCZjH1HOuFZW3Yx", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            guard let data = data else {
                print("no data received")
                return
            }

            guard let json = ((try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]) else {
                print("Doesn't contain JSON")
                return
            }
            
            if let reviews = json["reviews"] as? [[String:Any]] {
                
                let review1 = reviews[0]
                let review2 = reviews[1]
                
                let firstReview = review1["text"] as? String
                let secondReview = review2["text"] as? String
                
                let firstRating = review1["rating"] as? Int
                let secondRating = review2["rating"] as? Int
                let averageRating: Int = (firstRating! + secondRating!)/2
                
                self.firstURL = review1["url"] as? String
                self.secondURL = review2["url"] as? String

                    DispatchQueue.main.async {
                        self.firstReviewTextLabel.text = firstReview
                        self.secondReviewTextLabel.text = secondReview
                        
                        for i in 0...averageRating-1 {
                            self.starImageArray[i].image = #imageLiteral(resourceName: "Filled_Star")
                        }
                        
                        if averageRating != 5 {
                            for i in averageRating...4 {
                                self.starImageArray[i].image = #imageLiteral(resourceName: "Unfilled_Star")
                            }
                        }
                    }
                    
                }
            }
           task.resume()
        }
    }
