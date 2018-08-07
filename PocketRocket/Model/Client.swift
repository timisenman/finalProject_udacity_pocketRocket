////
////  Client.swift
////  PocketRocket
////
////  Created by Tim Isenman on 8/5/18.
////  Copyright © 2018 Timothy Isenman. All rights reserved.
////
//
//import Foundation
//
//class PRClient: NSObject {
//    
//    let shared = PRClient()
//    let session = URLSession.shared
//    
//    override init() {
//        super.init()
//    }
//    
//    // Complete this later
//    func taskWithURL(request: URLRequest, completionHandler: @escaping(_ data: [[String:AnyObject]]?, _ success: Bool?, _ error: String?) -> Void) {
//        var components = URLComponents()
//        let url = components.url
//        
//        let request = URLRequest(url: url!)
//        
//        let task = session.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                completionHandler(nil, nil, "Got yoself an error, bruh: \(error?.localizedDescription ?? "Some error")")
//                return
//            }
//            
//            guard let data = data else {
//                completionHandler(nil, nil, "No rockets, bro.")
//                return
//            }
//            
//            var parsedResult: [String:AnyObject]!
//            do {
//                parsedResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
//            }
//        }
//        task.resume()
//    }
//    
//}
