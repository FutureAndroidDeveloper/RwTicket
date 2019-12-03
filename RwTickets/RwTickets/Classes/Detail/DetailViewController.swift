//
//  DetailViewController.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/15/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, StoryboardInitializable {
    @IBOutlet weak var seekTicketButton: UIButton!
    
    // MARK: - Properties
    var viewModel: DetailViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        seekTicketButton.rx.tap
            .bind(to: viewModel.seekTicketTapped)
            .disposed(by: bag)
        
        viewModel.isSeekButtonActive
            .bind(to: seekTicketButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.telegramMessage
            .subscribe(onNext: { [weak self] message in
                self?.showTelegramMessage(message)
                }, onError: { [weak self] error in
                    self?.showTelegramMessage(error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    private func setupView() {
        let backButton = UIBarButtonItem()
        backButton.title = "Train Schedule"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func showTelegramMessage(_ message: String) {
        let alert = UIAlertController(title: "Telegram", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
