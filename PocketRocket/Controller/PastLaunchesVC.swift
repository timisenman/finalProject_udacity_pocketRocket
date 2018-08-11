//
//  TableViewController.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PastLaunchesViewController: UITableViewController {


    var previousLaunches:[String] = []
    let testArray:[String] = ["One","Two","Three"]
    var savedLaunches: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: Initially download all previous launches.
        //TODO: Then add only the launches that are viewed on the main screen
        
        pastLaunchRequest()
        
    }
    
    func fetchSavedLaunches() {
        //create fetch request
        //append all saved launches into savedLaunches array
    }

    
    // MARK: - Network request test:
    func pastLaunchRequest() {
        var c = URLComponents()
        c.host = SpaceX.host
        c.scheme = SpaceX.scheme
        c.path = SpaceX.allLaunches
        let yearLimit = URLQueryItem(name: "launch_year", value: "2018")
        c.queryItems = [yearLimit]
        let url = c.url!
        
//        PRClient.shared.taskForDictionary(url) { (data, success, error) in
////            self.previousLaunches.append(String(describing: data))
//            guard let newData = data else {
//                print("This data is fucked.")
//                return
//            }
//            
////            print(newData)
//            for flight in newData {
////                print("\(flight)\n")
////                print(flight["mission_name"])
//                guard let missionName = flight["mission_name"] as? String else {
//                    print("There is no mission name")
//                    return
//                }
//                
//                self.previousLaunches.append(missionName)
//            }
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }

    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedLaunches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)

        let launch = savedLaunches[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = launch.value(forKeyPath: LaunchDetails.missionName) as? String

        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
