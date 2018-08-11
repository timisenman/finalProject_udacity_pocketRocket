//
//  Constants.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/5/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

struct SpaceX {
    static let scheme = "https"
    static let host = "api.spacexdata.com"
    static let nextPath = "/v2/launches/next"
    static let latestPath = "/v2/launches/latest"
    static let allLaunches = "/v2/launches"
    static let upcomingLaunches = "/v2/launches/upcoming"
    static let queryItemStart = "start"
    static let queryValueStartDate = "2018-01-01"
}

struct LaunchDetails {
    static let dateUnix = "launch_date_unix"
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




