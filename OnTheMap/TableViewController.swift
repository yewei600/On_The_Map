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
    var studentLocations = [StudentInformation]()
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        studentLocations = StudentArray.sharedDataSource().studentLocations
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentNameCell")!
        let student = studentLocations[(indexPath as IndexPath).row]
        
        cell.textLabel?.text = student.firstName + " " + student.lastName
        print("student for row \(indexPath as IndexPath).row is \(student.firstName) \(student.lastName) \(student.mediaURL)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[(indexPath as IndexPath).row]
        
        //try catch for openning an URL
        guard UIApplication.shared.openURL(URL(string: student.mediaURL)!) else {
            let alert = UIAlertController(title: "", message: "Invalid URL!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
