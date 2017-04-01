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
    @IBOutlet weak var searchText: UITextField!
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
    
    @IBAction func searchButtonTapped(_ sender: AnyObject) {
        getSearchResult()
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
        let request = NSMutableURLRequest(url:myUrl!);
        // Set request HTTP method to GET.
        request.httpMethod = "GET"
        request.addValue("bearer a8iWu9Qx6o1dAhCHsHpIGyjjQDR6vYW3X0NSuCEoOUj5dO-7ZVC-Vrvu_kvOS-cCPTZxJOcAbz6OzSTJHfH7xlW3KjDBzfZt8tjQCYdQZF4g6aHFG9qARo1dRpfeWHYx", forHTTPHeaderField: "Authorization");
        sendRequest(request as URLRequest) { data in
            if let data = data {
                // do something
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        
                        // Get value by key
                        if let businesses = convertedJsonIntoDict["businesses"] as? NSArray {
                            var i = 0;
                            while (i<9) {
                                let business = businesses[i] as AnyObject
                                if let businessName = business["name"] as? String {
                                    print (businessName)
                                }
                                if let rating = business["rating"] as? Float {
                                    print ("\(rating) stars, based on ", terminator:"")
                                }
                                if let reviewCount = business["review_count"] as? Int {
                                    print ("\(reviewCount) reviews.")
                                }
                                if let distance = business["distance"] as? Float {
                                    print ("\(distance) meters away.")
                                }
                                i = i+1
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }

            }
        }}

    
    func sendRequest (_ request: URLRequest,completion: @escaping (Data?)->()){
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil{
                return completion(nil)
            }else{
                return completion(data)
            }
            }) .resume()
    }


}

