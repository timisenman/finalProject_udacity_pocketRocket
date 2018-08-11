//
//  ViewController.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/5/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class ViewController: UIViewController {
    
    // Static UI
    @IBOutlet weak var nextLaunchTitle: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    
    // Data-driven UI
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var missionDetails: UITextView!

    var savedNextLaunchDetails: [Launch] = []
    var launchArray: [NSManagedObject] = []
    var dataController: DataController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fix: This mostly works now.
        fetchData()
        print("Current array: \(launchArray)")
//        assignSavedData()
//        if launch.count < 1 {
//            nextLaunchRequest()
//        }
        assignSavedData()
        
        retrieveLaunches()
    }
    
    func assignSavedData() {
//        fetchData()
        launchDate.text = savedNextLaunchDetails[0].launchDate
        missionName.text = savedNextLaunchDetails[0].missionName
        missionDetails.text = savedNextLaunchDetails[0].details
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Launch> = Launch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            launchArray = result
            savedNextLaunchDetails = result
            print("Printing from Fetch: \(launchArray)")
        }
    }
    
    func retrieveLaunches() {
        
        var c = URLComponents()
        c.host = SpaceX.host
        c.scheme = SpaceX.scheme
        c.path = SpaceX.allLaunches
        let queryStart = URLQueryItem(name: SpaceX.queryItemStart, value: SpaceX.queryValueStartDate)
        c.queryItems = [queryStart]
        let url = c.url
        
        PRClient.shared.taskWithURL(url!) { (data, success, error) in
            
            guard (error == nil) else {
                fatalError(error ?? "Some error")
            }
            
            guard let flightsSince2018 = data else {
                print("This data is fucked.")
                return
            }
            
            for flight in flightsSince2018 {
                guard let launchDate = flight[LaunchDetails.dateUnix] as? Int else {
                    print("No launch date available here.")
                    return
                }
                
                guard let missionName = flight[LaunchDetails.missionName] as? String else {
                    print("No rocket name on this bitch.")
                    return
                }
                
                guard let launchSiteInfo = flight[LaunchDetails.launchSite] as? [String:AnyObject] else {
                    print("This shit took off from nowhere.")
                    return
                }
                
                guard let launchSiteName = launchSiteInfo[LaunchDetails.launchSiteName] as? String else {
                    print("A launch site has no name.")
                    return
                }
                
                guard let rocketInfo = flight[LaunchDetails.rocket] as? [String:AnyObject] else {
                    print("This launch contained no rockets...")
                    return
                }
                
                guard let rocketName = rocketInfo[LaunchDetails.rocketName] as? String else {
                    print("No mu' fuckin' name on this bitch.")
                    return
                }
                
                let launch = Launch(context: self.dataController.viewContext)
                launch.missionName = missionName
                launch.launchDate = self.dateFormatter(TimeInterval(launchDate))
                launch.details = "Rocket name: \(rocketName)\n"
                launch.location = launchSiteName
                launch.rocketName = rocketName
                
            }
            try? self.dataController.viewContext.save()
        }
    }
    
    func dateFormatter(_ date: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: date)
        return formatter.string(from:date)
    }
}


