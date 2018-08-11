import UIKit
import Foundation

struct SpaceX {
    static let scheme = "https"
    static let host = "api.spacexdata.com"
    static let nextPath = "/v2/launches/next"
    static let latestPath = "/v2/launches/latest"
    static let allLaunches = "/v2/launches"
    static let upcomingLaunches = "/v2/launches/upcoming"
}

struct LaunchDetails {
    static let dataUTC = "launch_date_utc"
    static let missionName = "mission_name"
    static let flightNumber = "flight_number"
    static let rocket = "rocket"
    static let rocketName = "rocket_name"
    static let secondStage = "second_stage"
    static let payload = "payloads"
    static let payloadID = "payload_id"
    static let payloadType = "payload_type"
    static let launchSite = "launch_site"
    static let launchSiteName = "site_name_long"
}

print(SpaceX.scheme)

var comp = URLComponents()

comp.scheme = SpaceX.scheme
comp.host = SpaceX.host
comp.path = SpaceX.nextPath

let url = comp.url
print(url!)

func taskWithURL(_ url: URL, handler: @escaping(_ data: [String:AnyObject]?, _ success: Bool?, _ errorString: String?) -> Void) {
    
    let request = URLRequest(url: url)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Go fuck yourself, from the Client")
            return
        }
        
        guard let rawData = data else {
            print("no data from Client")
            return
        }
        
        let parsedData: [String:AnyObject]!
        do {
            parsedData = try? JSONSerialization.jsonObject(with: rawData, options: .allowFragments) as! [String:AnyObject]
        }
        handler(parsedData, nil, nil)
    }
    
    task.resume()
}

taskWithURL(url!) { (data, success, string) in
    print(data ?? "No data")
}
