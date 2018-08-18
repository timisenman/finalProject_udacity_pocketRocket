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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // Data-driven UI
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var missionDetails: UITextView!
    @IBOutlet weak var launchSite: UITextView!
    

    // Data Shit
    var savedLaunches: [Launch] = []
    var nextLaunch: Launch?
    var dataController: DataController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = false
        
        fetchData { (success) in
            if success == true {
                
                for launch in self.savedLaunches {
                    guard let nextLaunchDate = launch.launchDate else {
                        fatalError()
                    }
                    
                    if nextLaunchDate > Date() {
                        self.nextLaunch = launch
                        print("The next launch was used.")
                    }
                    
                }
                
                guard let launchDate = self.nextLaunch?.launchDate else {
                    print("Date unwrapping failed :/")
                    return
                }
                
                self.missionName.text = self.nextLaunch?.missionName
                self.launchSite.text = self.nextLaunch?.location
                self.launchDate.text = self.dateFormatter(launchDate)
                self.missionDetails.text = self.nextLaunch?.details
                
            } else {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.retrieveLaunches()
                print("No data saved.")
            }
        }
        
        self.activityIndicator.isHidden = true
        
    }
    
    func fetchData(handler: @escaping(_ success: Bool?)->Void) {
        let fetchRequest: NSFetchRequest<Launch> = Launch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            savedLaunches = result
            if savedLaunches.count == 0 {
                handler(false)
            } else {
                handler(true)
            }
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
                self.displayAlert(with: error ?? "Check your internet connection.")
                return
            }
            
            guard let flight = data else {
                self.displayAlert(with: "This data is fucked. The server might be down.")
                return
            }
            
            guard let launchDateData = flight[LaunchDetails.dateUnix] as? Double else {
                print("No launch date available here.")
                return
            }
            
            guard let missionNameData = flight[LaunchDetails.missionName] as? String else {
                print("No rocket name on this mofo.")
                return
            }
            
            guard let launchSiteInfo = flight[LaunchDetails.launchSite] as? [String:AnyObject] else {
                print("This thing took off from nowhere.")
                return
            }
            
            guard let launchSiteName = launchSiteInfo[LaunchDetails.launchSiteName] as? String else {
                print("A launch site has no name.")
                return
            }
            
            guard let rocketInfo = flight[LaunchDetails.rocket] as? [String:AnyObject] else {
                print("This launch contained no rockets...?")
                return
            }
            
            guard let rocketName = rocketInfo[LaunchDetails.rocketName] as? String else {
                print("Ain't no name, mayne.")
                return
            }
            
            let launch = Launch(context: self.dataController.viewContext)
            launch.missionName = missionNameData
            launch.launchDate = (Date(timeIntervalSince1970:TimeInterval(launchDateData)))
            launch.details = "Rocket name: \(rocketName)\n"
            launch.location = launchSiteName
            launch.rocketName = rocketName
            
            DispatchQueue.main.async {
                self.missionName.text = missionNameData
                self.launchDate.text = self.dateFormatter(Date(timeIntervalSince1970: launchDateData))
                self.missionDetails.text = "Rocket name: \(rocketName)\n"
                self.launchSite.text = launchSiteName
            }
            
        }
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        try? self.dataController.viewContext.save()
    }
    
    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from:date)
    }
    
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


