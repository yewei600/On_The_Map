//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    //MARK: Properties
    
    //shared session
    var session = URLSession.shared
    
    //https://parse.udacity.com/parse/classes/StudentLocation
    
    //MARK: GET
    //, completionHandlerForGET: @escaping(_ result: AnyObject?, _ error: String) -> Void
    func taskForGetMethod(parameters: [String:AnyObject]) -> URLSessionTask {
        
//        var parametersWithApiKey = parameters
//        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
//        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters))
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        print("request taskForGetMethod === \(request)")
        
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                //completionHandlerForGET()
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            print("hello!!!   \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)")
            
            //populate the StudentInformation array
            self.convertDataWithCompletionHandler(data!)
            
        }
        task.resume()
        return task
    }
    
    func getStudentLocations()  {
        
       // let _ = taskForGetMethod(<#T##method: String##String#>, parameters: <#T##[String : AnyObject]#>)
        
    }
    
    func getStudentLocation() {
        
    }
    
    //MARK: POST
    func postStudentLocation(_ method: String, parameters: [String:AnyObject], jsonBody: String) {
        
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parametersWithApiKey))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        let task = session.dataTask(with: request as URLRequest){ (data,response,error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                //completionHandlerForGET()
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
        }
    }
    
    
    //MARK: PUT
    func putStudentLocation() {
        
    }
    
    //given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            //get an array of StudentInformation objects
            if let results = parsedResult?[JSONResponseKeys.results] as? [[String:AnyObject]] {
                StudentInformation.StudentArray = StudentInformation.studentInfoFromResults(results)
                print("StudentArray has length \(StudentInformation.StudentArray.count)")
            }
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)"]
            
           // completionHandler???
        }
    }
    
    
    // create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    //MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
