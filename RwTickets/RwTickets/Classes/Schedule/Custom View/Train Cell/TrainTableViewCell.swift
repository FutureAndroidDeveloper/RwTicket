//
//  TestCellTableViewCell.swift
//  testParsing
//
//  Created by Kiryl Klimiankou on 10/7/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class TrainTableViewCell: UITableViewCell {

    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var trainTypeImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var placesStackView: UIStackView!
    
    public static let identifier = "TrainCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(train: Train) {
        self.departureTimeLabel.text = train.departureTime
        self.arrivalTimeLabel.text = train.arrivalTime
        self.arrivalDateLabel.text = train.arrivalDate
        self.trainTypeImageView.image = UIImage(named: String(describing: train.type))
        self.fullNameLabel.text = "\(train.number) \(train.name)"
        self.placesStackView.removeAllArrangedSubviews()
        
        for place in train.places {
            let view = buildPlaceInfoView(with: place)
            self.placesStackView.addArrangedSubview(view)
        }
    }
    
    private func buildPlaceInfoView(with trainPlace: TrainPlace) -> UIView {
        let placeView = PlaceInfoView()
        placeView.translatesAutoresizingMaskIntoConstraints = false
        placeView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        placeView.placeTypeLabel.text = trainPlace.placeType
        placeView.placeCostLabel.text = trainPlace.placeCost
        
        if let vacantCount = trainPlace.vacantPlace {
            placeView.places = vacantCount
        } else {
            placeView.vacantPlaceLabel.text = nil
        }
        
        return placeView
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })
        // Remove the views from self
        removedSubviews.forEach { $0.removeFromSuperview() }
    }
}
