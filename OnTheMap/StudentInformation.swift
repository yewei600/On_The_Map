//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-07.
//  Copyright © 2017 EricWei. All rights reserved.

//https://discussions.udacity.com/t/cant-figue-out-where-to-store-student-information/37350/4


struct StudentInformation {
    
    let objectID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
//    let createdAt: Int   //DATE???
//    let updatedAt: Int   //DATE???
//    let ACL: AnyObject  //ACL???
    
//    init(dictionary: [String:AnyObject]) {
//        objectID = 
//    }
    
    static var StudentArray : [StudentInformation] = []
}

