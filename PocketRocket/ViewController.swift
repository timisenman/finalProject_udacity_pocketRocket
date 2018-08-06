//
//  ViewController.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/5/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
//    let rocketShip = PRClient()
    
    // UI
    @IBOutlet weak var nextLaunchTitle: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var missionDetails: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        requestTest()
    }
    
    func requestTest() {
        
        let url = URL(string: "https://api.spacexdata.com/v2/launches/next")
        let request = URLRequest(url: url!)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            guard let newData = data else {
                print("Ain't got now data up in this bitch")
                return
            }
            
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
            }
            
            //    static let secondStage = "second_stage"
            //    static let payload = "payloads"
            //    static let payloadID = "payload_id"
            //    static let payloadType = "payload_type"
            //    static let launchSite = "launch_site"
            //    static let launchSiteName = "site_name_long"
            
            guard let launchDateUTC = parsedResult["launch_date_utc"] else {
                print("No date, bitch")
                return
            }
            
            guard let upcomingName = parsedResult["mission_name"] else {
                print("No name, bitch")
                return
            }
            
            guard let flightNum = parsedResult["flight_number"] else {
                print("No number, bitch")
                return
            }
            
            guard let rocketBlob = parsedResult["rocket"] else {
                print("no rocket blob, idiot")
                return
            }
            
            guard let rocketNamae = rocketBlob["rocket_name"] else {
                print("no rocket name, idiot")
                return
            }
            
            guard let secondStage = rocketBlob["second_stage"] else {
                print("no second stage, idiot")
                return
            }
            
            DispatchQueue.main.async {
                self.launchDate.text = launchDateUTC as? String
                self.missionName.text = upcomingName as? String
                self.missionDetails.text = "Rocket Name: \(rocketNamae ?? "No name")\nRocket Payload: Test"
            }
            
//            guard let payloads = secondStage!["payloads"] else {
//                print("no payload, idiot")
//                return
//            }
//
//            guard let payloadType = payloads["payloads"] else {
//                print("no payload, idiot")
//                return
//            }
            
        }
        
        task.resume()
        
    }


}

