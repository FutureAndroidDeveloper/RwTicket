//
//  AppCoordinator.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/8/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let mainCoordinator = MainCoordinator(window: window)
        return coordinate(to: mainCoordinator)
    }
}
