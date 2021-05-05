//
//  SearchTrainInteractorTests.swift
//  MyTravelHelperTests
//
//  Created by Vivek on 05/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainInteractorTests: XCTestCase {
    
    
    func testFetchAllStation() {
        // Arrange
        let url = RailwayRequest.allStations.getEndPoint()
        let resource = Resource<StationData>(url)
        
        //Action
        MockAPIService.shared.load(resource: resource, completion: { result in
            let flag = MockAPIService.shared.serviceAreGettingCalled
            
            //Assert
            XCTAssertTrue(flag)
        })
    }
    
    func testFetchTrainsFromSource() {
        
        //Arrange
        let url = RailwayRequest.stationByCode.getEndPoint()
        let trainSourceCode = "A136"
        let param:[String: String] = ["StationCode": trainSourceCode]
        let resource = Resource<StationData>(url,param)
        
        //Action
        MockAPIService.shared.load(resource: resource, completion: { result in
            let flag = MockAPIService.shared.serviceAreGettingCalled
            
            //Assert
            XCTAssertTrue(flag)
        })
    }
    
    func testProceesTrainListforDestinationCheck() {
        
        //Arrange
        let url = RailwayRequest.trainMovement.getEndPoint()
        let trainCode = "colny"
        let dateString = Date().today("dd/MMM/yyyy")
        let param:[String: String] = ["TrainId": trainCode,
                                      "TrainDate": dateString]
        let resource = Resource<TrainMovementsData>(url,param)
        
        //Action
        MockAPIService.shared.load(resource: resource, completion: { result in
            let flag = MockAPIService.shared.serviceAreGettingCalled
            
            //Assert
            XCTAssertTrue(flag)
        })
    }
}


