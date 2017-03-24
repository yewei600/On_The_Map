//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-19.
//  Copyright © 2017 EricWei. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters = [
            "limit":100,
            "order":"-updatedAt"
            ] as [String : Any]
        
        ParseClient.sharedInstance().getStudentLocations(parameters: parameters as [String : AnyObject]) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    print("Downloaded the studentInfo! from tabbar VC")
                    let fvc = self.viewControllers![0] as! MapViewController
                    fvc.showAnnotations()
                }
            } else {
                let alert = UIAlertController(title: "", message: "Couldn't download pins, server error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func logoutSession(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSessionID { (success, error) in
            if success {
                //go back to the login screen
                DispatchQueue.main.async {
                    print("logging out!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

