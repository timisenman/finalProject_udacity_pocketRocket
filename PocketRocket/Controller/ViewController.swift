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
    @IBOutlet weak var launchSiteLabel: UILabel!
    @IBOutlet weak var detailsTextLabel: UILabel!
    
    
    // Data-driven UI
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var missionDetails: UITextView!
    @IBOutlet weak var launchSite: UITextView!
    

    // Data Shit
    var savedNextLaunchDetails: [Launch] = []
    var dataController: DataController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchData()
        
//        assignSavedData()
        retrieveLaunches()
        fetchData()
//        Fix: This mostly works now.
//        if savedNextLaunchDetails.isEmpty {
//            assignSavedData()
//            retrieveLaunches()
//        } else {
//            assignSavedData()
//        }
        
    }
    
//    func assignSavedData() {
//        launchDate.text = savedNextLaunchDetails[0].launchDate
//        missionName.text = savedNextLaunchDetails[0].missionName
//        missionDetails.text = savedNextLaunchDetails[0].details
//        launchSite.text = savedNextLaunchDetails[0].location
//    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Launch> = Launch.fetchRequest()
//        let predicate = NSPredicate(format: "launchDate > %@", String(describing: Date().timeIntervalSince1970))
//        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            savedNextLaunchDetails = result
            print("Results count: \(result.count)")
        }
    }
    
    func retrieveLaunches() {
        var c = URLComponents()
        c.host = SpaceX.host
        c.scheme = SpaceX.scheme
        c.path = SpaceX.nextLaunch
        let url = c.url
        
        PRClient.shared.taskWithURL(url!) { (data, success, error) in
            
            guard (error == nil) else {
                fatalError(error ?? "Some error")
            }
            
            guard let flight = data else {
                print("This data is fucked.")
                return
            }
            
            guard let launchDateData = flight[LaunchDetails.dateUnix] as? Int else {
                print("No launch date available here.")
                return
            }
            
            guard let missionNameData = flight[LaunchDetails.missionName] as? String else {
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
            launch.missionName = missionNameData
            launch.launchDate = self.dateFormatter(TimeInterval(launchDateData))
            launch.details = "Rocket name: \(rocketName)\n"
            launch.location = launchSiteName
            launch.rocketName = rocketName
//                self.savedNextLaunchDetails.append(launch)
//                try? self.dataController.viewContext.save()
            
//            Testing pure assignment of web request data
            DispatchQueue.main.async {
                self.missionName.text = missionNameData
                self.launchDate.text = self.dateFormatter(TimeInterval(launchDateData))
                self.missionDetails.text = "Rocket name: \(rocketName)\n"
                self.launchSite.text = launchSiteName
            }
            
        }
        try? self.dataController.viewContext.save()
    }
    
    func dateFormatter(_ date: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: date)
        return formatter.string(from:date)
    }
}


