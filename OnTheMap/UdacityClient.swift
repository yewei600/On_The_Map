//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//
import UIKit
import Foundation

class UdacityClient: NSObject {
    
    //MARK: Properties
    
    //shared session
    var session = URLSession.shared
    
    //configuration object
    //var config =
    
    //authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    //MARK: Initializers
    //???
    
    //    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorStr: String?) -> Void) {
    //
    //
    //
    //    }
    
    
    
    //MARK: GET
    func getSessionID(_ emailText:String, _ passwordText: String, _ completionHandlerForSessionID: @escaping (_ success: Bool, _ errorStr: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"ericwei94@gmail.com\", \"password\": \"Androidup15\"}}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //            func displayError(_ error: String) {
            //                print(error)
            //                performUIUpdatesOnMain {
            //                    self.setUIEnabled(true)
            //                    self.debugTextLabel.text = "Login Failed (Session ID)."
            //                }
            //            }
            
            guard (error == nil) else { // Handle error
                // displayError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                // displayError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                // displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                //displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
//            if let status = parsedResult["status"] as? Int, status  {
//                
//            }
            print("parsedResult == '\(parsedResult)'")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            completionHandlerForSessionID(true,nil)
            
        }
        task.resume()
    }
    
    
    //MARK: POST
    
    
    //MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
