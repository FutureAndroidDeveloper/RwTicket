//
//  ValidateService.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation

class ValidateService {
    typealias TravelData = (departure: String?, depError: String?,
        arrival: String?,arrError: String?,
        date: String?, dateError: String?)
    
    func isRussian(text: String) -> Bool {
        let inRussianRegEx = "^[а-яА-Я0-9_ ]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", inRussianRegEx)
        return predicate.evaluate(with: text)
    }
    
    /// dd.mm.yyyy
    func isDateValid(text: String) -> Bool {
        let regEx = "(([1-2][0-9])|([1-9])|(3[0-1])).((1[0-2])|([1-9])).[0-9]{4}"
        let datePredicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return datePredicate.evaluate(with: text)
    }
    
    func validateTravelData(_ data: TravelData) -> Bool {
        guard let departure = data.departure, let arrival = data.arrival,
            let date = data.date else {
                return false
        }
        // noErrors = depError == arrError == dateError == nil
        let noErrors = Set(arrayLiteral: data.depError, data.arrError, data.dateError, nil).count == 1
        let filedsNotEmpty = !departure.isEmpty && !arrival.isEmpty && !date.isEmpty
        return noErrors && filedsNotEmpty
    }
}
