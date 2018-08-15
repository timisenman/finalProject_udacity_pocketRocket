//
//  Client.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/5/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

class PRClient: NSObject {
    
    static let shared = PRClient()
    
    override init() {
        super.init()
    }
    
    // Complete this later
    func taskWithURL(_ url: URL, handler: @escaping(_ data: [String:AnyObject]?, _ success: Bool?, _ errorString: String?) -> Void) {
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Go fuck yourself, from the Client")
                return
            }
            
            guard let rawData = data else {
                print("new data from Client")
                return
            }
            
            let parsedData: [String:AnyObject]!
            do {
                parsedData = try? JSONSerialization.jsonObject(with: rawData, options: .allowFragments) as! [String:AnyObject]
            }
            
            handler(parsedData, true, nil)
        }
        
        task.resume()
    }
}
