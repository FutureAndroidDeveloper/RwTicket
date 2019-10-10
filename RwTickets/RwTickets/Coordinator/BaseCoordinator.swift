//
//  BaseCoordinator.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/8/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator<ResultType> {
    typealias CoordinatorResult = ResultType
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // Unique identifier of coordinator
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    // MARK: - Methods
    
    /// Stores coordinator to the `childCoordinators` dictionary.
    /// - Parameter coordinator: Child coordinator to store.
    private func store<Type>(coordinator: BaseCoordinator<Type>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    /// Release coordinator from the `childCoordinators` dictionary.
    private func free<Type>(coordinator: BaseCoordinator<Type>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method start() on that coordinator.
    /// 3. On the onNext: of returning observable of method start() removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of start() method.
    func coordinate<Type>(to coordinator: BaseCoordinator<Type>) -> Observable<Type> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
    }
    
    /// Starts job of the coordinator.
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
