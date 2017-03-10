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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var mapStringTextField: UITextField!
    
    
    @IBAction func exitInfoPostingEditor(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationOnMap(_ sender: Any) {
        print("find on the map button pressed.")
        let geocoder = CLGeocoder()
        do{
            geocoder.geocodeAddressString(mapStringTextField.text!, completionHandler: { (results, error) in
                if let _ = error {
                    //
                }
                else if (results!.isEmpty){
                    
                } else {
                    
                }
                
            })
        }
    }
    
    //MARK: Configure UI (Activity)
    func startActivity() {
        
    }
}
