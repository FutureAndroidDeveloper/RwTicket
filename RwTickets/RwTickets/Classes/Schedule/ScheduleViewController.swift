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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
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
        trainTableView.separatorColor = .black
        trainTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        activityIndicator.color = #colorLiteral(red: 0.003921568627, green: 0.7333333333, blue: 0.8, alpha: 1)
    }
    
    private func setupBindings() {
        viewModel.trains
            .bind(to: trainTableView.rx.items(cellIdentifier: TrainTableViewCell.identifier, cellType: TrainTableViewCell.self)) { (row, element, cell) in
                cell.configure(train: element, date: self.title!)
            }
            .disposed(by: bag)
        
        viewModel.dateTitle
            .bind(to: self.rx.title)
            .disposed(by: bag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: bag)

        viewModel.hideErrorMessage
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.hideErrorMessage
            .map { !$0 }
            .bind(to: trainTableView.rx.isHidden)
            .disposed(by: bag)
    }
}
