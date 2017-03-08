//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-07.
//  Copyright © 2017 EricWei. All rights reserved.

//https://discussions.udacity.com/t/cant-figue-out-where-to-store-student-information/37350/4


struct StudentInformation {
    
    var objectID: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: String
    let updatedAt: String
    // let ACL: String
    
    init(dictionary: [String:AnyObject]) {
        objectID = dictionary[ParseClient.JSONResponseKeys.objectID] as? String ?? ""
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as? String ?? ""
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as? String ?? ""
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as? String ?? ""
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String ?? ""
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Float ?? 0.0
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Float ?? 0.0
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] as? String ?? ""
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] as? String ?? ""
    }
    
    static func studentInfoFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        var studentArray = [StudentInformation]()
        
        for result in results {
            studentArray.append(StudentInformation(dictionary: result))
        }
        print("studentInfoFromResults:  studentArray has length==\(studentArray.count)")
        return studentArray
    }
    
    static var StudentArray : [StudentInformation] = []
}

