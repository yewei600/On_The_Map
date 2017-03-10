//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//
import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    //MARK: properties
    let studentLocations = StudentInformation.StudentArray
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        
        // tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentNameCell")!
        let student = studentLocations[(indexPath as IndexPath).row]
        
        cell.textLabel?.text = student.firstName + " " + student.lastName
        print("student name for row \(indexPath as IndexPath).row is \(student.firstName)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[(indexPath as IndexPath).row]
        
        //try catch for openning an URL
        UIApplication.shared.openURL(URL(string: student.mediaURL)!)
    }
}

