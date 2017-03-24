//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

class InfoPostingViewController: UIViewController, UITextFieldDelegate{
    
    enum ViewState {
        case findLocation, postLocation
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var postingMapView: MKMapView!
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    let parseClient = ParseClient.sharedInstance()
    var placemark: CLPlacemark? = nil
    var myInformation = StudentInformation(dictionary: [:])
    
    override func viewWillAppear(_ animated: Bool) {
        UdacityClient.sharedInstance().getUserData { (success, firstName, lastName) in
            if success {
                self.myInformation.firstName = firstName!
                self.myInformation.lastName = lastName!
            }
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapStringTextField.delegate = self
        mediaURLTextField.delegate = self
        
        configureUI(.findLocation)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mapStringTextField.resignFirstResponder()
        mediaURLTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func exitInfoPostingEditor(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationOnMap(_ sender: Any) {
        if mapStringTextField.text!.isEmpty {
            //displayAlert
            return
        }
        //start activity indicator
        startActivity()
        
        //add placemark
        let delayInSeconds = 1.5
        let delay = delayInSeconds * Double(NSEC_PER_SEC)
        let popTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(self.mapStringTextField.text!, completionHandler: { (results, error) in
                if let _ = error {
                    self.displayAlert("Could not geocode the string")
                }
                else if (results!.isEmpty){
                    self.displayAlert("No location found")
                } else {
                    print("placemark is \(results?[0])")
                    self.placemark = results![0]
                    self.configureUI(.postLocation)
                    
                    self.postingMapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
                }
            })
        }
    }
    
    @IBAction func submitStudentLocation(_ sender: Any) {
        self.startActivity()
        
        //check empty string
        if mediaURLTextField.text!.isEmpty {
            displayAlert("Must enter an URL!")
            return
        }
        
        let studentLocation = placemark?.location?.coordinate
        
        let jsonRequest = "{\"uniqueKey\": \"\(myInformation.uniqueKey)\", \"firstName\": \"\(myInformation.firstName)\", \"lastName\": \"\(myInformation.lastName)\",\"mapString\": \"\(mapStringTextField.text!)\", \"mediaURL\": \"https://\(mediaURLTextField.text!)\",\"latitude\": \(studentLocation!.latitude), \"longitude\": \(studentLocation!.longitude)}"
        
        //CHECK FOR NETWORK CONNECTVITY HERE!!! before posting student location
        if isInternetAvailable() {
            print("network is Available!")
            parseClient.postStudentLocation(jsonBody: jsonRequest){ (success, error) in
                if success {
                    let parameters = [
                        "limit":100,
                        "order":"-updatedAt"
                        ] as [String : Any]
                    //update the student location array
                    ParseClient.sharedInstance().getStudentLocations(parameters: parameters as [String:AnyObject], completionHandler: { (success, error) in
                        self.stopActivity()
                        if success {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                } else {
                    self.displayAlert("Couldn't add student location!")
                }
            }
        } else {
            displayAlert("No network connection")
        }
    }
    
    func displayAlert(_ message: String)  {
        DispatchQueue.main.async {
            self.stopActivity()
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configureUI(_ state: ViewState) {
        stopActivity()
        
        UIView.animate(withDuration: 1.0) {
            switch(state) {
            case .findLocation:
                self.infoLabel.text = "Where are you studying today?"
                self.findButton.isHidden = false
                self.submitButton.isHidden = true
                self.mapStringTextField.isHidden = false
                self.mediaURLTextField.isHidden = true
            case .postLocation:
                self.infoLabel.text = "Enter a media URL"
                self.findButton.isHidden = true
                self.submitButton.isHidden = false
                self.mapStringTextField.isHidden = true
                self.mediaURLTextField.isHidden = false
            }
        }
    }
    
    func startActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
