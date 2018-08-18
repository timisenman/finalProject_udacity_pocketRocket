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

    var savedLaunches: [Launch] = []
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedLaunches()
    }
    
    func fetchSavedLaunches() {
        let fetchRequest: NSFetchRequest<Launch> = Launch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "launchDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            savedLaunches = result
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == App.detailsSegue {
            let detailsVC = segue.destination as! PastLaunchDetailsVC
            detailsVC.selectedLaunch = sender as? Launch
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedLaunches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: App.cellID, for: indexPath)

        let launch = savedLaunches[(indexPath as NSIndexPath).row]
        
        if let name = launch.missionName, let date = launch.launchDate {
            cell.textLabel?.text = "\(name) - \(self.dateFormatter(date))"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let launch = savedLaunches[indexPath.row]
        performSegue(withIdentifier: App.detailsSegue, sender: launch)
        
    }
    
    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from:date)
    }
    
    
}
