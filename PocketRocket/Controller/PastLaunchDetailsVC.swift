//
//  PastLaunchDetailsVC.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class PastLaunchDetailsVC: UIViewController {
    
    //The segued Launch
    var selectedLaunch: Launch?

    //Static Labels
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    //Dynamic Labels
    @IBOutlet weak var launchTitle: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var launchLocation: UITextView!
    @IBOutlet weak var launchDetails: UITextView!
    
    //Buttons
    @IBOutlet weak var dismissButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        launchTitle.text = selectedLaunch?.missionName
        launchDate.text = selectedLaunch?.launchDate
        launchLocation.text = selectedLaunch?.location
        launchDetails.text = selectedLaunch?.details
    }
    
    @IBAction func dismissDetails(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
