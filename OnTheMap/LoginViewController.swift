//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Email or Password Empty."
        } else {
            UdacityClient.sharedInstance().getSessionID(emailTextField.text!, passwordTextField.text!, { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(errorString)
                    }
                }
            })
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationsTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
}

private extension LoginViewController {
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}
