//
//  Train.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct Train {
    enum TrainType: String {
        case internation = "Международные линии"
        case internationEconom = "Межрегиональные линии экономкласса"
        case regionalBusiness = "Региональные линии бизнес-класса"
        case regionalEconom = "Региональные линии экономкласса"
    }
    
    let name: String
    let number: String
    let departureCity: String
    let arrivalCity: String
    let departureTime: String
    let arrivalTime: String
    var departurDate: String?
    let arrivalDate: String?
    let roadTime: String
    let type: TrainType
    let places: [TrainPlace]
    
    mutating func setDepartureDate(_ date: String) {
        self.departurDate = date
    }
}

extension Train: Equatable {
    static func == (lhs: Train, rhs: Train) -> Bool {
        return lhs.departureCity == rhs.departureCity &&
            lhs.arrivalCity == rhs.arrivalCity &&
            lhs.name == rhs.name &&
            lhs.number == rhs.number
    }
}
