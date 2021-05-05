//
//  RailwayRequests.swift
//  MyTravelHelper
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation


/// Enum to generate Railway Request
enum RailwayRequest {
    
    //Reuest Subtype
    case allStations
    case stationByCode
    case trainMovement
    
    
    /// Method to generate end point on the basis of subtype
    /// - Returns: This will return final endpoint for URL
    func getEndPoint() -> String {
        var nextString = ""
        switch self {
        case .allStations:
            nextString = "/getAllStationsXML"
        case .stationByCode:
            nextString = "/getStationDataByCodeXML"
        case .trainMovement:
            nextString = "/getTrainMovementsXML"
        }
        
        let finalUrlString = AppConfig.apiBaseURL + nextString
        return finalUrlString
    }
}
