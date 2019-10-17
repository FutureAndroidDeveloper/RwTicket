//
//  MainViewModel.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/9/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    private let bag = DisposeBag()
    
    // MARK: - Input
    let departureCity: AnyObserver<String?>
    let arrivalCity: AnyObserver<String?>
    let date: AnyObserver<String?>
    let search: AnyObserver<Void>
    
    // MARK: - Output
    let departureError: Observable<String?>
    let arrivalError: Observable<String?>
    let dateError: Observable<String?>
    let searchTapped: Observable<TrainRoute>
    
    init(validateService: ValidateService = ValidateService()) {
        let _departureCity = PublishSubject<String?>()
        departureCity = _departureCity.asObserver()
        
        let _arrivalCity = PublishSubject<String?>()
        arrivalCity = _arrivalCity.asObserver()
        
        let _date = PublishSubject<String?>()
        date = _date.asObserver()
        
        let _search = PublishSubject<Void>()
        search = _search.asObserver()

        let _departureError = PublishSubject<String?>()
        departureError = _departureError.asObservable()
        
        let departureErrorStatus = _departureCity
            .compactMap{ $0 }
            .map { validateService.isRussian(text: $0) }
            .share(replay: 1, scope: .whileConnected)
        
        departureErrorStatus
            .filter { !$0 }
            .map { _ in return "Test Error Message" }
            .bind(to: _departureError)
            .disposed(by: bag)
        
        departureErrorStatus
            .filter { $0 }
            .map { _ in return nil }
            .bind(to: _departureError)
            .disposed(by: bag)
        
        let _arrivalError = PublishSubject<String?>()
        arrivalError = _arrivalError.asObservable()
        
        let arrivalErrorStatus = _arrivalCity
            .compactMap{ $0 }
            .map { validateService.isRussian(text: $0) }
            .share(replay: 1, scope: .whileConnected)
        
        arrivalErrorStatus
            .filter { !$0 }
            .map { _ in return "Test Error Message" }
            .bind(to: _arrivalError)
            .disposed(by: bag)
        
        arrivalErrorStatus
            .filter { $0 }
            .map { _ in return nil }
            .bind(to: _arrivalError)
            .disposed(by: bag)
        
        let _dateError = PublishSubject<String?>()
        dateError = _dateError.asObservable()
        
        let dateErrorStatus = _date
            .skip(2)
            .compactMap{ $0 }
            .map { validateService.isDateValid(text: $0) }
            .share(replay: 1, scope: .whileConnected)
        
        dateErrorStatus
            .filter { !$0 }
            .map { _ in return "Test Error Message" }
            .bind(to: _dateError)
            .disposed(by: bag)
        
        dateErrorStatus
            .filter { $0 }
            .map { _ in return nil }
            .bind(to: _dateError)
            .disposed(by: bag)
        
        let travelData = Observable.combineLatest(_departureCity, self.departureError, _arrivalCity, self.arrivalError, _date, self.dateError)
            .share(replay: 1)
        
        // seacrh only when all fields are filled without errors
        searchTapped = _search.asObservable().withLatestFrom(travelData)
            .filter { validateService.validateTravelData($0) }
            .map { routeData -> TrainRoute in
                return TrainRoute(from: routeData.0!, to: routeData.2!, date: routeData.4!)
            }
    }
}
