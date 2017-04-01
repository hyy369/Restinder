//
//  FirstViewController.swift
//  Restinder
//
//  Created by HYY on 3/31/17.
//  Copyright © 2017 Yangyang He. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var url = "https://www.yelp.com/"
    var gBusinesses: NSArray = []
    var offset = 0

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bigImage.isHidden = true
        nameLabel.isHidden = true
        ratingLabel.isHidden = true
        distanceLabel.isHidden = true
        priceLabel.isHidden = true
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        refreshResult()

    }
    
    
    func refreshResult() {
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
        let urlWithParams = apiUrl + "?category='food'&latitude=\(lat)&longitude=\(long)&open_now=true&offset=\(self.offset)"
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
                        self.offset += 20
                    } else {
                        self.offset += Int(resultTotal)
                    }
                    print(total)
                }
                if let businesses = convertedJsonIntoDict["businesses"] as? NSArray {
                    let business0 = businesses[0] as AnyObject
                    if let resultImageUrl = business0["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image1.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image1)
                        }

                    }
                    let business1 = businesses[1] as AnyObject
                    if let resultImageUrl = business1["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image2.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image2)
                        }
                        
                    }
                    let business2 = businesses[2] as AnyObject
                    if let resultImageUrl = business2["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image3.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image3)
                        }
                        
                    }
                    let business3 = businesses[3] as AnyObject
                    if let resultImageUrl = business3["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image4.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image4)
                        }
                        
                    }
                    let business4 = businesses[4] as AnyObject
                    if let resultImageUrl = business4["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image5.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image5)
                        }
                        
                    }
                    let business5 = businesses[5] as AnyObject
                    if let resultImageUrl = business5["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image6.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image6)
                        }
                        
                    }
                    let business6 = businesses[6] as AnyObject
                    if let resultImageUrl = business6["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image7.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image7)
                        }
                        
                    }
                    let business7 = businesses[7] as AnyObject
                    if let resultImageUrl = business7["image_url"] as? String {
                        print ("Image: \(resultImageUrl)")
                        if let checkedUrl = URL(string: resultImageUrl) {
                            self.image8.contentMode = .scaleAspectFit
                            self.downloadImage(checkedUrl, self.image8)
                        }
                        
                    }
                        
                    }
//                    let randomPick = Int(arc4random_uniform(total+1))
//                    print (randomPick)
//                    let business = businesses[randomPick] as AnyObject
//                    if let resultName = business["name"] as? String {
//                        print (resultName)
//                        name = resultName
//                    }
//                    if let resultRating = business["rating"] as? Float {
//                        print ("\(resultRating) stars, based on ", terminator:"")
//                        rating = resultRating
//                    }
//                    if let resultReviewCount = business["review_count"] as? Int {
//                        print ("\(resultReviewCount) reviews.")
//                        reviewCount = resultReviewCount
//                    }
//                    if let resultDistance = business["distance"] as? Float {
//                        print ("\(resultDistance) meters away.")
//                        distance = Int(resultDistance)
//                    }
//                    if let resultUrl = business["url"] as? String {
//                        print ("Go to Yelp page: \(resultUrl)")
//                        self.url = resultUrl
//                    }
//                    if let resultImageUrl = business["image_url"] as? String {
//                        print ("Image: \(resultImageUrl)")
//                        imageUrl = resultImageUrl
//                    }
//                    if let resultPrice = business["price"] as? String {
//                        print ("Price: \(resultPrice)")
//                        price = resultPrice
//                    }
//                }
            }
            
        }

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

    func getDataFromUrl(_ url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(_ url: URL, _ iView: UIImageView) {
        print("Download Started")
        getDataFromUrl(url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                iView.image = UIImage(data: data)
            }
        }
    }


}

