//
//  SearchTrainRouter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
class SearchTrainRouter: PresenterToRouterProtocol {
    
    static func createModule() -> SearchTrainViewController {
        
        let homeVC = SearchTrainViewController.instantiateFromStoryboard()
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = SearchTrainPresenter()
        let interactor: PresenterToInteractorProtocol = SearchTrainInteractor()
        let router:PresenterToRouterProtocol = SearchTrainRouter()

        homeVC.presenter = presenter
        presenter.view = homeVC
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return homeVC
    }
}
