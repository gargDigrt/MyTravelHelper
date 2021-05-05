//
//  Constants.swift
//  MyTravelHelper
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation


enum AppConfig {
    
    static let apiBaseURL = "http://api.irishrail.ie/realtime/realtime.asmx"
}

enum Storyboard: String {
    case main
    
    func name() -> String {return rawValue.capitalized}
}


enum NetworkingError: Error {
    case domainError
    case decodingError
    case connectivityError
    
}

enum HttpMethod: String {
    case get
    case post
}


let PROGRESS_INDICATOR_VIEW_TAG: Int = 10
