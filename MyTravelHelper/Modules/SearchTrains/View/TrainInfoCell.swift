//
//  TrainInfoCell.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class TrainInfoCell: UITableViewCell {
    
    //IBOutlet
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var sourceTimeLabel: UILabel!
    @IBOutlet weak var destinationInfoLabel: UILabel!
    @IBOutlet weak var souceInfoLabel: UILabel!
    @IBOutlet weak var trainCode: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    weak var delegate: FavTrainDelegate?
    var train: StationTrain! {
        didSet{
            trainCode.text = train.trainCode
            souceInfoLabel.text = train.stationFullName
            sourceTimeLabel.text = train.expDeparture
            favButton.isSelected = train.isfavourite
            if let _destinationDetails = train.destinationDetails {
                destinationInfoLabel.text = _destinationDetails.locationFullName
                destinationTimeLabel.text = _destinationDetails.expDeparture
            }
        }
    }

    @IBAction func favButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        train.isfavourite = sender.isSelected
        delegate?.markTrainFavourite(train: train)
    }
}
