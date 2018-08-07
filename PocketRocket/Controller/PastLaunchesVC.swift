//
//  TableViewController.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class PastLaunchesViewController: UITableViewController {

    var previousLaunches:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: Initially download all previous launches.
        //TODO: Then add only the launches that are viewed on the main screen
        requestTest()
    }
    
    // MARK: - Network request test:
    func requestTest() {
        
        let url = URL(string: "https://api.spacexdata.com/v2/launches")
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
            
            var parsedResult: [[String:AnyObject]]!
            do {
                parsedResult = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [[String : AnyObject]]
            }
            
            DispatchQueue.main.async {
                print(parsedResult)
            }
        }
        task.resume()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
