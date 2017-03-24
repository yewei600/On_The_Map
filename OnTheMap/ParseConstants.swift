//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    struct Constants {
        //MARK:  API Key & APP ID
        // static let ApiKey = "QuWThTasefdiRmTesafesaux3YaDasesafasefseUSEpUesafesfKo7aBYM737yKasdfasefd4gY"
        // static let ApplicationID = "QrX47CA9fyusafseaGasefewLdsL7o5asefasEb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        //MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
    }
    
    struct MyInformation {
        static let uniqueKey = "1234"
        static let firstName = "Eric"
        static let lastName = "W"
    }
    
    struct JSONResponseKeys {
        static let results = "results"
        
        //MARK: Student Info
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
    
}
