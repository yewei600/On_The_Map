//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Email or Password Empty."
        } else {
            //setUIEnabled(false)
            UdacityClient.sharedInstance().getSessionID(emailTextField.text!, passwordTextField.text!, { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(errorString)
                    }
                }
            })
            
            //            UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            //                performUIUpdatesOnMain {
            //                    if success {
            //                        self.completeLogin()
            //                    } else {
            //                        self.displayError(errorString)
            //                    }
            //                }
            //            }
            
        }
        
        
        
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationsTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
}

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}
