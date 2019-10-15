//
//  ScheduleViewController.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScheduleViewController: UIViewController, StoryboardInitializable {
    @IBOutlet weak var trainTableView: UITableView!
    
    var viewModel: ScheduleViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        let trainCellNib = UINib(nibName: "TrainTableViewCell", bundle: nil)
        trainTableView.register(trainCellNib, forCellReuseIdentifier: TrainTableViewCell.identifier)
        trainTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupBindings() {
        viewModel.trains
            .bind(to: trainTableView.rx.items(cellIdentifier: TrainTableViewCell.identifier, cellType: TrainTableViewCell.self)) { (row, element, cell) in
                cell.configure(train: element)
            }
            .disposed(by: bag)
    }
}
