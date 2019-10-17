//
//  ScheduleViewModel.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

class ScheduleViewModel {
    // MARK: - Input
    let route: AnyObserver<TrainRoute>
    let selectedTrain: AnyObserver<Train>
    
    // MARK: - Output
    let trains: Observable<[Train]>
    let dateTitle: Observable<String>
    let isLoading: Observable<Bool>
    let hideErrorMessage: Observable<Bool>
    let trainDidSelect: Observable<Train>
    
    init(networkService: NetworkService = NetworkService(),
         parseService: ParseService = ParseService()) {
        
        let _route = ReplaySubject<TrainRoute>.create(bufferSize: 1)
        route = _route.asObserver()
        
        let _train = PublishSubject<Train>()
        selectedTrain = _train.asObserver()
        trainDidSelect = _train.asObservable()
        
        let loadedTrains = _route
            .flatMap { networkService.getHtmlTrains(from: $0.departureCity, to: $0.arrivalCity, at: $0.date) }
            .flatMap { parseService.parseTrains(with: $0) }
        
        let trainsWithDate = Observable.combineLatest(loadedTrains, _route)
            .map { trains, route in
                return trains.map { train -> Train in
                    var trainCopy = train
                    trainCopy.setDepartureDate(route.date)
                    return trainCopy
                }
            }
            .take(1)
            .share(replay: 1, scope: .whileConnected)
        
        isLoading = trainsWithDate.map { _ in false }
        dateTitle = _route.map { $0.date }
        trains = trainsWithDate
        
        hideErrorMessage = trainsWithDate
            .filter { $0.isEmpty }
            .map { _ in false }
    }
}
