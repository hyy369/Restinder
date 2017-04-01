//
//  SecondViewController.swift
//  Restinder
//
//  Created by HYY on 3/31/17.
//  Copyright © 2017 Yangyang He. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


class SecondViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var url = "https://www.yelp.com/"

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var distanceText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        businessImage.isUserInteractionEnabled = true
        businessImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocationCoordinate2D = manager.location!.coordinate
        lat = String(location.latitude)
        long = String(location.longitude)
    }
    
    @IBAction func luckyButton(_ sender: AnyObject) {
        getSearchResult()
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    func getSearchResult(){
        var name = ""
        var rating: Float = 0
        var reviewCount = 0
        var distance = 0
        var imageUrl = ""
        var price = ""
        var total: UInt32 = 0
        print("lat=\(lat)")
        print("long=\(long)")
        // Send HTTP GET Request
        if lat.characters.count < 1 {
            lat = "37.2698845"
        }
        if long.characters.count < 1 {
            long = "-76.7159085"
        }
        print("lat=\(lat)")
        print("long=\(long)")
        // Define server side script URL
        let apiUrl = "https://api.yelp.com/v3/businesses/search"
        let urlWithParams = apiUrl + "?category='food'&latitude="+lat+"&longitude="+long+"&open_now=true"
        let headers: HTTPHeaders = [
            "Authorization": "bearer a8iWu9Qx6o1dAhCHsHpIGyjjQDR6vYW3X0NSuCEoOUj5dO-7ZVC-Vrvu_kvOS-cCPTZxJOcAbz6OzSTJHfH7xlW3KjDBzfZt8tjQCYdQZF4g6aHFG9qARo1dRpfeWHYx",
        ]
        
        Alamofire.request(urlWithParams, headers: headers).responseJSON { response in
            //print(response)
            if let convertedJsonIntoDict = response.result.value as? NSDictionary {
                // Get value by key
                if let resultTotal = convertedJsonIntoDict["total"] as? UInt32 {
                    total = resultTotal
                    if total > 20 {
                        total = 19
                    }
                    print(total)
                }
                if let businesses = convertedJsonIntoDict["businesses"] as? NSArray {
                    let randomPick = Int(arc4random_uniform(total+1))
                    print (randomPick)
                    let business = businesses[randomPick] as AnyObject
                    if let resultName = business["name"] as? String {
                        print (resultName)
                        name = resultName
                    }
                    if let resultRating = business["rating"] as? Float {
                        print ("\(resultRating) stars, based on ", terminator:"")
                        rating = resultRating
                    }
                    if let resultReviewCount = business["review_count"] as? Int {
                        print ("\(resultReviewCount) reviews.")
                        reviewCount = resultReviewCount
                    }
                    if let resultDistance = business["distance"] as? Float {
                        print ("\(resultDistance) meters away.")
                        distance = Int(resultDistance)
                    }
                    if let resultUrl = business["url"] as? String {
                        print ("Go to Yelp page: \(resultUrl)")
                        self.url = resultUrl
                    }
                    if let resultImageUrl = business["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        imageUrl = resultImageUrl
                    }
                    if let resultPrice = business["price"] as? String {
                        print ("Price: \(resultPrice)")
                        price = resultPrice
                    }
                }
            }
            self.name.text = name
            self.ratingText.text = "\(rating) stars based on \(reviewCount) reviews."
            let distanceInMile = distance/1609
            if distanceInMile < 1 {
                self.distanceText.text = "Less than 1 mile away."
            } else {
                self.distanceText.text = "\(distanceInMile) miles away."
            }
            self.priceText.text = price
            if let checkedUrl = URL(string: imageUrl) {
                self.businessImage.contentMode = .scaleAspectFit
                self.downloadImage(checkedUrl)
            }

        }
    }
    
    func getDataFromUrl(_ url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(_ url: URL) {
        print("Download Started")
        getDataFromUrl(url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.businessImage.image = UIImage(data: data)
            }
        }
    }
}

