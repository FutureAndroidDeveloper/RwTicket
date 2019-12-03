//
//  DetailViewModel.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/15/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

enum CustomError: Error {
    case notOddValue
    case weakSelf
}

class DetailViewModel {
    // MARK: - Propeties
    private let bag = DisposeBag()
    private var trainValue: Train!
    private let networkService: NetworkService!
    private let telegramService: Telegram!
    private let parseService: ParseService!
    
    // MARK: - Input
    let train: AnyObserver<Train>
    let seekTicketTapped: AnyObserver<Void>
    
    // MARK: - Output
    let isSeekButtonActive: Observable<Bool>
    let telegramMessage: Observable<String>
    
    init(networkService: NetworkService = NetworkService(),
         parseService: ParseService = ParseService(),
         telegramService: Telegram = TelegramService()) {
        self.networkService = networkService
        self.parseService = parseService
        self.telegramService = telegramService
        
        let _train = PublishSubject<Train>()
        train = _train.asObserver()
        
        let _seekTicket = PublishSubject<Void>()
        seekTicketTapped = _seekTicket.asObserver()
        
        let _isActive = PublishSubject<Bool>()
        isSeekButtonActive = _isActive.asObservable()
        
        let _message = PublishSubject<String>()
        telegramMessage = _message.asObservable()
        
        _train
            .subscribe(onNext: { [weak self] (train) in
                guard let self = self else { return }
                self.trainValue = train
            })
            .disposed(by: bag)
        
        _seekTicket
            .map { _ in false }
            .bind(to: _isActive)
            .disposed(by: bag)

        let isFreePlace = _seekTicket
            .flatMap { [weak self] _ -> Single<Bool> in
                guard let self = self else { return .error(CustomError.weakSelf) }
                return self.checkTicket()
                    .retryWhen { error -> Observable<Int> in
                        return error.flatMap { _ -> Observable<Int> in
                            print("No vacant places. retry after 5 seconds!")
                            return Observable<Int>.timer(5, scheduler: MainScheduler.instance).take(1)
                        }
                    }
            }
            .share(replay: 1, scope: .whileConnected)
        
        isFreePlace
            .bind(to: _isActive)
            .disposed(by: bag)
        
        isFreePlace.withLatestFrom(_train)
            .flatMap { [weak self] train -> Observable<String> in
                guard let self = self else { return .empty() }
                return self.telegramService.sendMessage(train)
            }
            .bind(to: _message)
            .disposed(by: bag)
    }
    
    // MARK: - Private Methods
    private func checkTicket() -> Single<Bool> {
        return networkService.getHtmlTrains(from: trainValue.departureCity, to: trainValue.arrivalCity, at: trainValue.departurDate!)
            .flatMap { [weak self] html -> Observable<[Train]> in
                guard let self = self else { return .empty() }
                return self.parseService.parseTrains(with: html) }
            .take(1)
            .flatMap { [weak self] trains -> Single<Bool> in
                guard let self = self else { return .error(CustomError.notOddValue) }
                return self.checkPlaces(trains: trains, selectedTrain: self.trainValue)
            }
            .asSingle()
    }
    
    /// return success if there is free place
    private func checkPlaces(trains: [Train], selectedTrain : Train) -> Single<Bool> {
        return Single.create { single -> Disposable in
            guard let train = trains.first(where: { $0 == selectedTrain }) else {
                single(.error(CustomError.notOddValue))
                return Disposables.create()
            }
            
            var flag = false
            train.places.forEach { place in
                guard let _ = place.vacantPlace else { return }
                flag = true
            }
            
            switch flag {
            case true: single(.success(flag))
            case false: single(.error(CustomError.notOddValue))
            }
            return Disposables.create()
        }
    }
}
