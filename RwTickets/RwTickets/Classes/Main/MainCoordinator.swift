//
//  MainCoordinator.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/9/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import RxSwift

class MainCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let mainViewController = MainViewController.initFromStoryboard()
        let mainViewModel = MainViewModel()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        mainViewController.viewModel = mainViewModel
        
        mainViewModel.searchTapped
            .subscribe(onNext: { _ in
                print("search")
            })
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return .never()
    }
}
