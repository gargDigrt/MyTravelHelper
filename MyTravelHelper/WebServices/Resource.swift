//
//  Resource.swift
//  MyTravelHelper
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation


/// A model class for the resource to form a URLRequest
struct Resource<T: Codable> {
    var urlRequest: URLRequest

    init(_ url: String,_ params: [String: String]? = nil,_ method: HttpMethod = .get) {
        var urlComp = URLComponents(string: url)!
        var queries:[URLQueryItem] = []
        if let allParms = params {
        for (key, value) in allParms{
           let newQuery = URLQueryItem(name: key, value: value)
            queries.append(newQuery)
        }
        }
        urlComp.queryItems = queries
        urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = method.rawValue
    }
}
