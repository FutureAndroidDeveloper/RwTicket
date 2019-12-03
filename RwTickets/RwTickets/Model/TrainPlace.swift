//
//  TrainPlace.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct TrainPlace {
    let placeType: String?
    let placeCost: String
    let vacantPlace: Int?
}

extension TrainPlace: CustomStringConvertible {
    var description: String {
        return "\(placeType ?? "") \(placeCost.trimmingCharacters(in: CharacterSet.whitespaces)) \(vacantPlace ?? 0)"
    }
}
