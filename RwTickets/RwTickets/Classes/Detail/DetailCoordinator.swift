//
//  DetailCoordinator.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/15/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

class DetailCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let train: Train
    
    init(navigationController: UINavigationController, train: Train) {
        self.navigationController = navigationController
        self.train = train
    }
    
    override func start() -> Observable<Void> {
        let detailViewController = DetailViewController.initFromStoryboard()
        let detailViewModel = DetailViewModel()
        
        detailViewController.viewModel = detailViewModel
        navigationController.pushViewController(detailViewController, animated: true)
        detailViewModel.train.onNext(train)
        
        return navigationController.rx.willShow
            .compactMap { $0.viewController as? ScheduleViewController }
            .map { _ in Void() }
            .take(1)
    }
}
