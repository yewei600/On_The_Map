//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingViewController: UIViewController{
    
    enum ViewState {
        case findLocation, postLocation
    }
    
    // MARK: Properties
    let parseClient = ParseClient.sharedInstance()
    var placemark: CLPlacemark? = nil
    
    // MARK: Outlets
    @IBOutlet weak var postingMapView: MKMapView!
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle
        
    @IBAction func exitInfoPostingEditor(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationOnMap(_ sender: Any) {
        if mapStringTextField.text!.isEmpty {
            //displayAlert
            return
        }
        //start activity indicator
        
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
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        //check empty string
        if mediaURLTextField.text!.isEmpty {
            displayAlert("Must enter an URL!")
            return
        }
        
        let handleRequest: ((NSError?, String) -> Void) = { (error, mediaURL) in
            if let _ = error {
                self.displayAlert("Student location couldn't be posted") { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        
        let studentLocation = placemark?.location?.coordinate
        
        let jsonRequest = "{\"uniqueKey\": \"1234\", \"firstName\": \"Eric\", \"lastName\": \"Wei\",\"mapString\": \"\(mapStringTextField.text!)\", \"mediaURL\": \"\(mediaURLTextField.text!)\",\"latitude\": \(studentLocation!.latitude), \"longitude\": \(studentLocation!.longitude)}"
        
        print(jsonRequest)
        
        parseClient.postStudentLocation(jsonBody: jsonRequest){ (success, error) in
            
            //ParseClient.sharedInstance().getStudentLocations(parameters: parameters as [String:AnyObject])

        }
        
    }
    
    
    func displayAlert(_ message: String, completionHandler:((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
        
        }
    }
    
    
    
    //MARK: Configure UI (Activity)
    func setupUI() {
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func configureUI(_ state: ViewState) {
        
        
    }
    
    func startActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
}
