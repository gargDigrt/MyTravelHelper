//
//  Extensions.swift
//  MyTravelHelper
//
//  Created by Vivek on 06/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation


extension Date {
 
    func today(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        return dateString
    }
}
