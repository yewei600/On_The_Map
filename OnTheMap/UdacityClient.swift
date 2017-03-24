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
    
    //authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    //MARK: POST
    func getSessionID(_ emailText:String, _ passwordText: String, _ completionHandlerForGetSessionID: @escaping (_ success: Bool, _ errorStr: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".data(using: String.Encoding.utf8)
        
        print("request == '\(request.httpBody)'")
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGetSessionID(false,error)
            }
            
            guard (error == nil) else { // Handle error
                sendError("Login Failed")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                print("login failed statusCode == \(statusCode)")
                if statusCode == 403 {
                    sendError("Wrong username or password")
                } else if statusCode == 404 {
                    sendError("Failed to connect to Udacity")
                }
                return
            }
            
            let range = Range(5 ..< data!.count)
            guard let newData = data?.subdata(in: range) else {
                sendError("Login Failed")
                return
            }
            
            var parsedJSON = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            
            let account = parsedJSON["account"] as? [String:AnyObject]
            StudentArray.sharedDataSource().myUniqueKey = account?["key"] as! String
            
            print("uniqueKey is \(StudentArray.sharedDataSource().myUniqueKey)")
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            completionHandlerForGetSessionID(true,nil)
            
        }
        
        task.resume()
    }
    
    func getUserData(_ completionHandler: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(StudentArray.sharedDataSource().myUniqueKey)")!)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandler(false, nil, nil)
            }
            
            guard (error == nil) else { // Handle error…
                sendError("There was an error deleting Session ID: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            //parse the first and last names
            let jsonResponse = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            let user = jsonResponse["user"] as! [String:AnyObject]
            let firstName = user["first_name"] as! String
            let lastName = user["last_name"] as! String
            
            completionHandler(true,firstName,lastName)
        }
        task.resume()
    }
    
    
    //MARK: DELETE
    func deleteSessionID (_ completionHandlerForDeleteSessionID: @escaping (_ success: Bool, _ errorStr: String?) -> Void)  {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForDeleteSessionID(false,error)
            }
            
            guard (error == nil) else { // Handle error…
                sendError("There was an error deleting Session ID: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print("Delete sessionID: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)")
            
            completionHandlerForDeleteSessionID(true,nil)
        }
        task.resume()
    }
    
    
    //MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
