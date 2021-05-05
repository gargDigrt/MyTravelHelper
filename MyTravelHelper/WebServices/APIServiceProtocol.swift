//
//  APIServiceProtocol.swift
//  MyTravelHelper
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func load<T>(resource: Resource<T>, completion: @escaping(Result<T, NetworkingError>) -> Void)
}

