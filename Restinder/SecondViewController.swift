//
//  SecondViewController.swift
//  Restinder
//
//  Created by HYY on 3/31/17.
//  Copyright © 2017 Yangyang He. All rights reserved.
//

import UIKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
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
        // Send HTTP GET Request
         getSearchResult()
//        print(result)
//        self.outputLabel.text = result.name
//        if let checkedUrl = URL(string: result.imageUrl) {
//            businessImage.contentMode = .scaleAspectFit
//            downloadImage(checkedUrl)
//        }
    }
    
    func getSearchResult() {

        
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
        let urlWithParams = apiUrl + "?term='food'&latitude="+lat+"&longitude="+long+"&open_now=true"
        // Create NSURL Object
        let myUrl = URL(string: urlWithParams);
        // Creaste URL Request
        var request = URLRequest(url: myUrl!);
        // Set request HTTP method to GET.
        request.httpMethod = "GET"
        request.setValue("bearer a8iWu9Qx6o1dAhCHsHpIGyjjQDR6vYW3X0NSuCEoOUj5dO-7ZVC-Vrvu_kvOS-cCPTZxJOcAbz6OzSTJHfH7xlW3KjDBzfZt8tjQCYdQZF4g6aHFG9qARo1dRpfeWHYx", forHTTPHeaderField: "Authorization");
        sendRequest(request: request as NSURLRequest) { name, rating, reviewCount, distance,url,imageUrl in
//            print(result)
            self.outputLabel.text = name
            if let checkedUrl = URL(string: imageUrl) {
                self.businessImage.contentMode = .scaleAspectFit
                self.downloadImage(checkedUrl)
            }
//            return (name, rating, reviewCount, distance, url, imageUrl)
        }
//        return ("",0.0,0,0,"","")
    }
    
    
    func sendRequest(request: NSURLRequest, completion: @escaping (_ name: String, _ rating: Float, _ reviewCount: Int, _ distance: Int, _ url: String, _ imageUrl: String)-> Void){
        var name = ""
        var rating: Float = 0
        var reviewCount = 0
        var distance = 0
        var url = ""
        var imageUrl = ""
        var total: UInt32 = 0
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
                if let data = data {
                    do {
                    // do something
                    //                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        // Get value by key
                        if let resultTotal = convertedJsonIntoDict["businesses"] as? UInt32 {
                            total = resultTotal
                        }
                        if let businesses = convertedJsonIntoDict["businesses"] as? NSArray {
                            let randomPick = Int(arc4random_uniform(total))
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
                                url = resultUrl
                            }
                            if let resultImageUrl = business["image_url"] as? String {
                                print ("Image: \(resultImageUrl)")
                                imageUrl = resultImageUrl
                            }
                        }
                    }
                    completion(name, rating, reviewCount, distance, url, imageUrl)
                    } catch let error as NSError {
                        print (error)
                    }
                
                }
            }.resume()
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

