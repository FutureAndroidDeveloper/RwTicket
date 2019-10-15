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
        
        return .never()
    }
}
