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
    var gBusinesses: Array<AnyObject> = []
    var offset = 0
    var myImages: Array<UIImageView> = []

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
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bigImage.isHidden = true
        nameLabel.isHidden = true
        ratingLabel.isHidden = true
        distanceLabel.isHidden = true
        priceLabel.isHidden = true
        actIndicator.isHidden = true
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        myImages = [image1, image2, image3, image4, image5, image6, image7, image8]

        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image1.isUserInteractionEnabled = true
        image1.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image2.isUserInteractionEnabled = true
        image2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image3.isUserInteractionEnabled = true
        image3.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image4.isUserInteractionEnabled = true
        image4.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image5.isUserInteractionEnabled = true
        image5.addGestureRecognizer(tapGestureRecognizer5)
        
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image6.isUserInteractionEnabled = true
        image6.addGestureRecognizer(tapGestureRecognizer6)
        
        let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image7.isUserInteractionEnabled = true
        image7.addGestureRecognizer(tapGestureRecognizer7)
        
        let tapGestureRecognizer8 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image8.isUserInteractionEnabled = true
        image8.addGestureRecognizer(tapGestureRecognizer8)
        
        let tapGestureRecognizerBig = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        bigImage.isUserInteractionEnabled = true
        bigImage.addGestureRecognizer(tapGestureRecognizerBig)
        
        refreshResult()

    }
    
    
    @IBAction func didTappedRefreshButton(_ sender: Any) {
        refreshResult()
    }
    
    
    func refreshResult() {
        bigImage.isHidden = true
        nameLabel.isHidden = true
        ratingLabel.isHidden = true
        distanceLabel.isHidden = true
        priceLabel.isHidden = true
        actIndicator.isHidden = false
        actIndicator.startAnimating()
        for smallImage in myImages {
            smallImage.isHidden = false
        }
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
        let urlWithParams = apiUrl + "?category='food'&latitude=\(lat)&longitude=\(long)&open_now=true&limit=8&offset=\(self.offset)"
        let headers: HTTPHeaders = [
            "Authorization": "bearer a8iWu9Qx6o1dAhCHsHpIGyjjQDR6vYW3X0NSuCEoOUj5dO-7ZVC-Vrvu_kvOS-cCPTZxJOcAbz6OzSTJHfH7xlW3KjDBzfZt8tjQCYdQZF4g6aHFG9qARo1dRpfeWHYx",
            ]
        
        Alamofire.request(urlWithParams, headers: headers).responseJSON { response in
            //print(response)
            if let convertedJsonIntoDict = response.result.value as? NSDictionary {
                // Get value by key
                if let resultTotal = convertedJsonIntoDict["total"] as? UInt32 {
                    total = resultTotal
                    if total > 8 {
                        total = 7
                        self.offset += 8
                    } else {
                        self.offset += Int(resultTotal)
                    }
                    print(total)
                }
                if let businesses = convertedJsonIntoDict["businesses"] as? NSArray {
                    self.gBusinesses = businesses as Array<AnyObject>
                    var i = 0
                    while i < 8 && i < businesses.count {
                        let business = businesses[i] as AnyObject
                        if let resultImageUrl = business["image_url"] as? String {
                            print ("Image: \(resultImageUrl)")
                            if let checkedUrl = URL(string: resultImageUrl) {
                                self.myImages[i].contentMode = .scaleToFill
                                self.downloadImage(checkedUrl, self.myImages[i])
                            }
                        }
                        i += 1
                    }
                    
                }
            }
            self.actIndicator.stopAnimating()
            self.actIndicator.isHidden = true
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

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        var selectedBusiness: AnyObject
        selectedBusiness = gBusinesses[0]
        switch tapGestureRecognizer.view as! UIImageView {
        case image1:
            selectedBusiness = gBusinesses[0]
        case image2:
            selectedBusiness = gBusinesses[1]
        case image3:
            selectedBusiness = gBusinesses[2]
        case image4:
            selectedBusiness = gBusinesses[3]
        case image5:
            selectedBusiness = gBusinesses[4]
        case image6:
            selectedBusiness = gBusinesses[5]
        case image7:
            selectedBusiness = gBusinesses[6]
        case image8:
            selectedBusiness = gBusinesses[7]
        case bigImage:
            print("Tapped.")
            print("Going to Yelp: \(url)")
            UIApplication.shared.openURL(URL(string: url)!)
        default:
            break
        }
        for smallImage in myImages {
            smallImage.isHidden = true
        }
        bigImage.isHidden = false
        nameLabel.isHidden = false
        ratingLabel.isHidden = false
        distanceLabel.isHidden = false
        priceLabel.isHidden = false
        
        var rating: Float = 0.0
        if let resultImageUrl = selectedBusiness["image_url"] as? String {
            print ("Image: \(resultImageUrl)")
            if let checkedUrl = URL(string: resultImageUrl) {
                self.bigImage.contentMode = .scaleToFill
                self.downloadImage(checkedUrl,self.bigImage)
            }

        }
        if let resultName = selectedBusiness["name"] as? String {
            print (resultName)
            nameLabel.text = resultName
        }
        if let resultRating = selectedBusiness["rating"] as? Float {
            print ("\(resultRating) stars, based on ", terminator:"")
            rating = resultRating
        }
        if let resultReviewCount = selectedBusiness["review_count"] as? Int {
            print ("\(resultReviewCount) reviews.")
            ratingLabel.text = "\(rating) stars based on \(resultReviewCount) reviews."
        }
        if let resultDistance = selectedBusiness["distance"] as? Float {
            print ("\(resultDistance) meters away.")
            let distanceInMile = resultDistance/1609
            if distanceInMile < 1 {
                self.distanceLabel.text = "Less than 1 mile away."
            } else {
                let distanceStr = String(format: "%.1f", distanceInMile)
                self.distanceLabel.text = "\(distanceStr) miles away."
            }
        }
        if let resultPrice = selectedBusiness["price"] as? String {
            print ("Price: \(resultPrice)")
            priceLabel.text = resultPrice
        }
        if let resultUrl = selectedBusiness["url"] as? String {
            print ("Yelp page: \(resultUrl)")
            self.url = resultUrl
        }
    }
}

