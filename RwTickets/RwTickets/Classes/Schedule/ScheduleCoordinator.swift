//
//  ScheduleCoordinator.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

class ScheduleCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let trainRoute: TrainRoute
    
    init(navigationController: UINavigationController, trainRoute: TrainRoute) {
        self.navigationController = navigationController
        self.trainRoute = trainRoute
    }
    
    override func start() -> Observable<Void> {
        let scheduleViewModel = ScheduleViewModel()
        let scheduleViewController = ScheduleViewController.initFromStoryboard()
        
        scheduleViewController.viewModel = scheduleViewModel
        navigationController.pushViewController(scheduleViewController, animated: true)
        
        scheduleViewModel.route.onNext(trainRoute)
        scheduleViewModel.trainDidSelect
            .flatMap { [weak self] train -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.showDetailViewController(in: self.navigationController, with: train) }
            .subscribe(onNext: { _ in
                print("detail VC END")
            })
            .disposed(by: disposeBag)
        
        return navigationController.rx.willShow
            .compactMap { $0.viewController as? MainViewController }
            .map { _ in Void() }
            .take(1)
    }
    
    private func showDetailViewController(in navigationController: UINavigationController, with train: Train) -> Observable<Void> {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, train: train)
        return coordinate(to: detailCoordinator)
    }
}
