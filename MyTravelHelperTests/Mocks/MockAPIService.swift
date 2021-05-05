//
//  MockAPIService.swift
//  MyTravelHelper
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
@testable import MyTravelHelper

class MockAPIService: NSObject, APIServiceProtocol {
    static let shared = MockAPIService()
    private override init() {}
    
    var serviceAreGettingCalled = false
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable, T : Encodable {
        serviceAreGettingCalled = true
        completion(.failure(.decodingError))
    }
    
    
}
