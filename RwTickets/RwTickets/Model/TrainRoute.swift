//
//  TrainRoute.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/15/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct TrainRoute {
    let departureCity: String
    let arrivalCity: String
    let date: String
    
    init(from departure: String, to arrival: String, date: String) {
        departureCity = departure
        arrivalCity = arrival
        
        // dd.mm.yyyy to yyyy-mm-dd
        self.date = date.split(separator: ".").reversed().map(String.init).reduce("") { previous, current -> String in
            previous + current + "-"
        }.dropLast().description
    }
}
