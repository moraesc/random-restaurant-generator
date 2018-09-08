//
//  ViewController.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 7/26/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

class RandomRestaurantViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var restaurantInfoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generateButton: GenerateButton!
    
    var mainController: MainViewController?
    var restaurants = [Restaurant]()
    var latitude: Double?
    var longitude: Double?
    var selectedCuisine: String?
    var selectedPrice: String?
    var selectedPriceValue: String?
    var restaurantID: String?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateButton.setTitle("Regenerate", for: .normal)
        
        setupView()
        fetchData()
        
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self as? UIGestureRecognizerDelegate
        restaurantInfoView.addGestureRecognizer(tap)
        
        generateButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func handleTap() {
        performSegue(withIdentifier: "RestaurantDetailSegueID", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantDetailSegueID" {
            if let nextVC = segue.destination as? RestaurantDetailViewController {
                nextVC.name = nameLabel.text
                nextVC.details = detailsLabel.text
                nextVC.id = restaurantID
                nextVC.latitude = latitude
                nextVC.longitude = longitude
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        restaurantInfoView.layer.cornerRadius = 20
        restaurantInfoView.layer.borderColor = UIColor.newGray.cgColor
        restaurantInfoView.layer.borderWidth = 2
    }
    
    func getSelectedPrice() {
        if selectedPrice == "$" {
            selectedPriceValue = "1"
        } else if selectedPrice == "$$" {
            selectedPriceValue = "2"
        } else if selectedPrice == "$$$" {
            selectedPriceValue = "3"
        }
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func fetchData() {
        
        activityIndicator.startAnimating()
        
        getSelectedPrice()
        
        let latitudeString: String = String(format:"%f", latitude!)
        let longitudeString: String = String(format:"%f", longitude!)
        
        let cuisineString = selectedCuisine ?? ""
        let priceString = selectedPriceValue ?? ""
        
        
        let myUrl = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(cuisineString)&latitude=\(latitudeString)&longitude=\(longitudeString)&price=\(priceString)")
        
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
                        
            if let businesses = json["businesses"] as? [[String:Any]] {
                for business in businesses {
                    let name = business["name"] as? String
                    let location = business["location"] as? [String:Any]
                    let id = business["id"] as? String
                    let price = business["price"] as? String
                    if let category = business["categories"] as? [[String:Any]] {
                        let title = category[0]
                        let cuisine = title["title"] as? String
                        if let address = location!["address1"] as? String? {
                            self.restaurants.append(Restaurant(name: name!, address: address!, cuisine: cuisine!, id: id!, price: price!))
                        }
                        else {
                            self.restaurants.append(Restaurant(name: name!, address: "", cuisine: cuisine!, id: id!, price: price!))
                        }
                    }
                }
            }
            self.randomGenerator(restaurants: self.restaurants)
        }
        task.resume()
    }
    
    //generate random restaurant
    func randomGenerator(restaurants: [Restaurant]) {
        let randomNumber = Int(arc4random_uniform(UInt32(restaurants.count)))
        let randomRestaurant = restaurants[randomNumber]
        
        restaurantID = randomRestaurant.id
        
        DispatchQueue.main.async {
            self.nameLabel.text = randomRestaurant.name
            self.detailsLabel.text = randomRestaurant.address + "\n\(randomRestaurant.cuisine)" + "\n\(randomRestaurant.price)"
            self.activityIndicator.stopAnimating()
        }
    }
}
