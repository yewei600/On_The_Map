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
    
    //MARK: GET
    func getStudentLocations(parameters: [String:AnyObject], completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void)
        -> URLSessionTask {
            let request = NSMutableURLRequest(url: parseURLFromParameters(parameters))
            request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandler(false, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
                    return
                }
                
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error)")
                    return
                }
                
                //populate the StudentInformation array
                self.convertDataWithCompletionHandler(data!)
                
                completionHandler(true,nil)
            }
            task.resume()
            return task
    }
    
    //MARK: POST
    func postStudentLocation(jsonBody: String, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        print("in postStudentLocation()")
        
        let task = session.dataTask(with: request as URLRequest){ (data,response,error) in
            
            guard (error == nil) else {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(false, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(false, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandler(true, nil)
        }
        
        task.resume()
    }
    
    //given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            //get an array of StudentInformation objects
            if let results = parsedResult?[JSONResponseKeys.results] as? [[String:AnyObject]] {
                StudentArray.sharedDataSource().studentLocations = StudentInformation.studentInfoFromResults(results)
                print("StudentArray has length \(StudentArray.sharedDataSource().studentLocations.count)")
            }
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)"]
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
