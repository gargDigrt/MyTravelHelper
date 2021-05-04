//
//  Protocols.swift
//  MyTravelHelper
//
//  Created by Vivek on 04/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main
    
    func name() -> String {return rawValue.capitalized}
}

/// This protocol will allow ViewController to get instantiated easily
protocol StoryBoardAble: class {
    //Properties
    static var storyBoard: Storyboard {get}
    static var identifier: String {get}
    
}

//MARK:- Functions
extension StoryBoardAble where Self: UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    /// To instantiate a particular UIViewController
    /// - Returns: UIViewController Instance
    static func instantiateFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyBoard.name(), bundle: nil)
        
        guard let expectedVC = storyboard.instantiateViewController(withIdentifier: self.identifier) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(storyBoard.name())")
        }
        return expectedVC
    }
}

