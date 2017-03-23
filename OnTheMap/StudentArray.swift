//
//  StudentArray.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-19.
//  Copyright © 2017 EricWei. All rights reserved.
//

import Foundation

class StudentArray: NSObject {
    
    var studentLocations = [StudentInformation]()
    
    override init(){
        super.init()
    }
    
    static var sharedInstance = StudentArray()
    
    class func sharedDataSource() -> StudentArray {
        return sharedInstance
    }
}

