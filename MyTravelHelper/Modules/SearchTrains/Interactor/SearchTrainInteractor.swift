//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing
import Alamofire

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        
        let url = RailwayRequest.allStations.getEndPoint()
        let resource = Resource<Stations>(url)
        
        
        if Reach().isNetworkReachable() == true {
            
            APIService.shared.load(resource: resource, completion: { result in
                switch result {
                case .success(let stations):
                    self.presenter?.stationListFetched(list: stations.stationsList)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        let url = RailwayRequest.stationByCode.getEndPoint()
        let param:[String: String] = ["StationCode": sourceCode]
        let resource = Resource<StationData>(url,param)
        
        if Reach().isNetworkReachable() {
            APIService.shared.load(resource: resource, completion: { result in
                
                switch result{
                case .success(let stationData):
                    if stationData.trainsList.count > 0 {
                    self.proceesTrainListforDestinationCheck(trainsList: stationData.trainsList)
                    } else {
                        self.presenter!.showNoTrainAvailbilityFromSource()
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    self.presenter?.showNoTrainAvailbilityFromSource()
                }
            })
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let today = Date()
        let group = DispatchGroup()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        let dateString = formatter.string(from: today)
        for index in 0..<trainsList.count {
            group.enter()
            let url = RailwayRequest.trainMovement.getEndPoint()
            let param:[String: String] = ["TrainId": trainsList[index].trainCode,
                                          "TrainDate": dateString]
            let resource = Resource<TrainMovementsData>(url,param)
            
            if Reach().isNetworkReachable() {
                
                APIService.shared.load(resource: resource, completion: { result in
                    switch result {
                    case .success(let trainMovementsData):
                        if trainMovementsData.trainMovements.count > 0 {
                            let _movements = trainMovementsData.trainMovements
                                let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                                let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                                let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                                let isDestinationAvailable = desiredStationMoment.count == 1

                                if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                                    _trainsList[index].destinationDetails = desiredStationMoment.first
                                }
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                    group.leave()
                })
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}
