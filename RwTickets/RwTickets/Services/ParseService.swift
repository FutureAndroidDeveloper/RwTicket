//
//  ParseService.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import SwiftSoup
import RxSwift

class ParseService {
    func parseTrains(with html: String) -> Observable<[Train]> {
        return Observable<[Train]>.create { [weak self] observer in
            var trains = [Train]()
            guard let self = self else {
                observer.onNext(trains)
                return Disposables.create()
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let htmlTrains: Elements = try doc.select("tr")
                
                htmlTrains.forEach { train in
                    guard let newTrain = self.buildTrain(for: train) else {
                        return
                    }
                    trains.append(newTrain)
                }
            } catch let error {
                observer.onError(error)
            }

            observer.onNext(trains)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    
    private func buildTrain(for element: Element) -> Train? {
        let id = try? element.select("small.train_id")
        let name = try? element.select("a.train_text")
        let place = try? element.select("li.train_place")
        let price = try? element.select("li.train_price")
        
        let depCity = try? element.select("a.train_start-place")
        let depTime = try? element.select("b.train_start-time")
        
        let arrCity = try? element.select("a.train_end-place")
        let arrTime = try? element.select("b.train_end-time")
        
        let roadTime = try? element.select("span.train_time-total")
        let type = try? element.select("div.train_description")
        let noteList = try? element.select("li.train_note")
        
        
        let textPlace = try? place?.text()
        let textPrice = try? price?.text()
        let textId = try? id?.text()
        let textName = try? name?.text()
        
        let textDepTime = try? depTime?.text()
        let textDepCity = try? depCity?.text()
        
        let textArrTime = try? arrTime?.text().split(separator: ",").first
        let textArrDate = try? (arrTime?.text().split(separator: " ").count)! > 1 ? try? arrTime?.text().split(separator: ",").last : nil
        let textArrCity = try? arrCity?.text()
        
        let textRoadTime = try? roadTime?.text()
        let textType = try? type?.text()
        let textNoteList = try? noteList?.text().split(separator: " ")
        
        let trainType = Train.TrainType(rawValue: textType!)
        
        let priceList = textPrice?.split(separator: ".").map(String.init)
        let placeList = textPlace?.split(separator: " ").map(String.init)
        let placeTypeList = textNoteList?.map(String.init)
        
        guard let traintType = trainType else {
            print("UNKOWN train TYPE --> \(textType ?? "nil")")
            return nil
        }
        var placesList = [TrainPlace]()
        
        for i in 0..<priceList!.count {
            let placeType = placeTypeList!.count <= i ? placeTypeList!.last: placeTypeList![i]
            var vacantCount = ""
            
            if !placeList!.isEmpty {
                vacantCount = placeList!.count <= i ? placeList!.last!: placeList![i]
            }
            let trainPlace = TrainPlace(placeType: placeType, placeCost: priceList![i], vacantPlace: Int(vacantCount))
            placesList.append(trainPlace)
        }
        
        let newTrain = Train(name: textName!, number: textId!, departureCity: textDepCity!, arrivalCity: textArrCity!, departureTime: textDepTime!, arrivalTime: String(textArrTime!), arrivalDate: String(textArrDate?.dropFirst() ?? ""), roadTime: textRoadTime!, type: trainType!, places: placesList)
        return newTrain
    }
}
