//
//  SearchTrainViewController.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
import SwiftSpinner
import DropDown

class SearchTrainViewController: UIViewController, StoryBoardAble {
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTxtField: UITextField!
    @IBOutlet weak var trainsListTable: UITableView!

    var stationsList:[Station] = [Station]()
    var trains:[StationTrain] = [StationTrain]()
    var favTrains:[StationTrain] = [StationTrain]()
    var presenter: ViewToPresenterProtocol?
    var dropDown = DropDown()
    var transitPoints:(source:String,destination:String) = ("","")
    var displayFavouriteTrains = false
    static var storyBoard: Storyboard {return .main}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.view = self
        switchTableViewVisibility(flag: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        if stationsList.count == 0 {
            SwiftSpinner.useContainerView(view)
            SwiftSpinner.show("Please wait loading station list ....")
            presenter?.fetchallStations()
        }
    }

    @IBAction func searchTrainsTapped(_ sender: Any) {
        view.endEditing(true)
        showProgressIndicator(view: self.view)
        presenter?.searchTapped(source: transitPoints.source, destination: transitPoints.destination)
    }
    
    @IBAction func clearSearch(_ : UIButton) {
        sourceTxtField.text = ""
        destinationTextField.text = ""
        trains.removeAll()
        displayFavouriteTrains = true
        reloadTrainList()
    }
    
    private func switchTableViewVisibility(flag: Bool) {
        DispatchQueue.main.async {
            self.trainsListTable.isHidden = flag
        }
    }
    
    private func reloadTrainList() {
        DispatchQueue.main.async {
            self.trainsListTable.reloadData()
        }
    }
}

extension SearchTrainViewController: PresenterToViewProtocol {
    
    func showNoInterNetAvailabilityMessage() {
        switchTableViewVisibility(flag: true)
        hideProgressIndicator(view: self.view)
        showAlert(title: "No Internet", message: "Please Check you internet connection and try again", actionTitle: "Okay")
    }

    func showNoTrainAvailbilityFromSource() {
        switchTableViewVisibility(flag: !(favTrains.count>0))
        DispatchQueue.main.async{
            hideProgressIndicator(view: self.view)
        }
        showAlert(title: "No Trains", message: "Sorry No trains arriving source station in another 90 mins", actionTitle: "Okay")
    }

    func updateLatestTrainList(trainsList: [StationTrain]) {
        hideProgressIndicator(view: self.view)
        trains = trainsList
        switchTableViewVisibility(flag: false)
        displayFavouriteTrains = false
        if trainsList.count > 0 {
            reloadTrainList()
        }
    }

    func showNoTrainsFoundAlert() {
        switchTableViewVisibility(flag: !(favTrains.count>0))
        hideProgressIndicator(view: self.view)
        showAlert(title: "No Trains", message: "Sorry No trains Found from source to destination in another 90 mins", actionTitle: "Okay")
    }

    func showAlert(title:String,message:String,actionTitle:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showInvalidSourceOrDestinationAlert() {
        switchTableViewVisibility(flag: true)
        hideProgressIndicator(view: self.view)
        showAlert(title: "Invalid Source/Destination", message: "Invalid Source or Destination Station names Please Check", actionTitle: "Okay")
    }

    func saveFetchedStations(stations: [Station]?) {
        if let _stations = stations {
          self.stationsList = _stations
        }
        SwiftSpinner.hide()
    }
    
    func manageFavouriteTrain(train: StationTrain) {
        if train.isfavourite {
            favTrains.append(train)
        } else
        if let indx = favTrains.firstIndex(where: {$0==train}) {
            favTrains.remove(at: indx)
            if displayFavouriteTrains {
                reloadTrainList()
            }
        }

    }
}

extension SearchTrainViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown = DropDown()
        dropDown.anchorView = textField
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = stationsList.map {$0.stationDesc}
        dropDown.selectionAction = { (index: Int, item: String) in
            if textField == self.sourceTxtField {
                self.transitPoints.source = item
            }else {
                self.transitPoints.destination = item
            }
            textField.text = item
        }
        dropDown.show()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dropDown.hide()
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let inputedText = textField.text {
            var desiredSearchText = inputedText
            if string != "\n" && !string.isEmpty{
                desiredSearchText = desiredSearchText + string
            }else {
                desiredSearchText = String(desiredSearchText.dropLast())
            }

            dropDown.dataSource = stationsList.map{$0.stationCode}
            dropDown.show()
            dropDown.reloadAllComponents()
        }
        return true
    }
}

extension SearchTrainViewController: UITableViewDataSource,UITableViewDelegate {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayFavouriteTrains ? favTrains.count : trains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "train", for: indexPath) as! TrainInfoCell
        let displayingTrains = displayFavouriteTrains ? favTrains : trains
        let train = displayingTrains[indexPath.row]
        infoCell.train = train
        infoCell.delegate = self
        return infoCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchTrainViewController: FavTrainDelegate {
    func markTrainFavourite(train: StationTrain) {
        manageFavouriteTrain(train: train)
    }
}
