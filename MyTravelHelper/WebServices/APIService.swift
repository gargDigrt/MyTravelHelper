//
//  APIService.swift
//  MyTravelHelper
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
import XMLParsing



class APIService: NSObject, APIServiceProtocol {
    
    
    static let shared = APIService()
    private override init() {}
    
    /// Method to request URLRequest
    /// - Parameters:
    ///   - resource: Resource of generic type
    ///   - completion: Result object
    func load<T>(resource: Resource<T>, completion: @escaping(Result<T, NetworkingError>) -> Void) {
        
        URLSession.shared.dataTask(with: resource.urlRequest){ data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            let decoded = try? XMLDecoder().decode(T.self, from: data)
            if let result = decoded {
                completion(.success(result))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
