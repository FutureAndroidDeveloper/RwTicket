//
//  ViewController.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/7/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import KDCalendar
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

class MainViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var departureCityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var arrivalCityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var departureCityTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var departureCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrivalCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateCenterXConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var searchTopConstraint: NSLayoutConstraint!
    private var dateBottomConstraint: NSLayoutConstraint!
    private var calendarCenterXConstraint: NSLayoutConstraint!
    private var calendarBottomConstraint: NSLayoutConstraint!
    
    var viewModel: MainViewModel!
    private let bag = DisposeBag()
    private var calendarView: CalendarView!
    private var startCalendarDate: Date!
    private var endCalendarDate: Date!
    private var buttonSpace: CGFloat = 50
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateSetupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        dateTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.showCalendar()
            })
            .disposed(by: bag)
        
        dateTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                self?.hideCalendar()
            })
            .disposed(by: bag)
        
        searchButton.rx.tap
            .bind(to: viewModel.search)
            .disposed(by: bag)
        
        departureCityTextField.rx.text
            .bind(to: viewModel.departureCity)
            .disposed(by: bag)
        
        arrivalCityTextField.rx.text
            .bind(to: viewModel.arrivalCity)
            .disposed(by: bag)
        
        dateTextField.rx.text
            .bind(to: viewModel.date)
            .disposed(by: bag)
        
        viewModel.departureError
            .bind(to: departureCityTextField.rx.error)
            .disposed(by: bag)
        
        viewModel.arrivalError
            .bind(to: arrivalCityTextField.rx.error)
            .disposed(by: bag)
        
        viewModel.dateError
            .bind(to: dateTextField.rx.error)
            .disposed(by: bag)
    }
    
    private func setupView() {
        let emptyKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dateTextField.inputView = emptyKeyboardView
        
        searchButton.layer.cornerRadius = searchButton.frame.width / 5
        searchButton.alpha = 0
        searchTopConstraint = NSLayoutConstraint(item: searchButton, attribute: .top, relatedBy: .equal,
                                                 toItem: dateTextField, attribute: .bottom,
                                                 multiplier: 1.0, constant: buttonSpace)
        
        searchTopConstraint.constant += buttonSpace
        searchTopConstraint.isActive = true
        departureCityTopConstraint.constant = view.frame.height / 10
        
        departureCenterXConstraint.constant = -view.frame.width
        arrivalCenterXConstraint.constant = -view.frame.width
        dateCenterXConstraint.constant = -view.frame.width
        
        CalendarView.Style.locale = Locale(identifier: "ru_Ru")

        CalendarView.Style.headerBackgroundColor = .clear
        CalendarView.Style.headerTextColor = .white
        CalendarView.Style.headerFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        CalendarView.Style.subHeaderFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        CalendarView.Style.cellColorDefault = .white
        CalendarView.Style.cellTextColorWeekend = .red
        CalendarView.Style.cellTextColorDefault = .black
        CalendarView.Style.cellSelectedColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        CalendarView.Style.cellSelectedBorderColor = .green
        CalendarView.Style.cellSelectedBorderWidth = 4
        CalendarView.Style.cellTextColorToday = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    }
    
    private func animateSetupView() {
        departureCenterXConstraint.constant = 0
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        arrivalCenterXConstraint.constant = 0
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        dateCenterXConstraint.constant = 0
        UIView.animate(withDuration: 0.6, delay: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        searchTopConstraint.constant = buttonSpace
        UIView.animate(withDuration: 0.6, delay: 0.7, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.0, options: [], animations: {
            self.searchButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func showCalendar() {
        searchTopConstraint.constant = 40 + view.frame.width * 0.9 + 20
        let searchButtonPosition = searchButton.frame.origin.y + searchButton.frame.height + searchTopConstraint.constant
        let bottomOffset = CGPoint(x: 0, y: (scrollView.contentSize.height + 16) - view.frame.width * 0.9)
        
        if searchButtonPosition > view.frame.height {
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.addCalendarView()
        self.calendarCenterXConstraint.constant = 0
        UIView.animate(withDuration: 0.6, delay: 0.22, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideCalendar() {
        calendarCenterXConstraint.constant = view.frame.width * 1.1
        searchTopConstraint.constant = 50
        searchTopConstraint.isActive = true
        calendarBottomConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.calendarView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.calendarView.removeFromSuperview()
        })
    }
    
    private func addCalendarView() {
        calendarView = CalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(calendarView)
        searchTopConstraint.isActive = false
        
        calendarCenterXConstraint = calendarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: view.frame.width)
        calendarBottomConstraint = searchButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([
            calendarView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            calendarView.heightAnchor.constraint(equalTo: calendarView.widthAnchor, multiplier: 1.0),
            calendarView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 40),
            calendarBottomConstraint,
            calendarCenterXConstraint
            ])
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.multipleSelectionEnable = false
        self.view.layoutIfNeeded()
    }
}

extension MainViewController: CalendarViewDataSource {
    func startDate() -> Date {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")!
        let truncatedDate = Calendar.current.date(from: dateComponents)!
        startCalendarDate = truncatedDate
        return truncatedDate
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 2
        dateComponents.day = -2
        let today = Date()
        let twoMonthsInAdvance = calendarView.calendar.date(byAdding: dateComponents, to: today)!
        endCalendarDate = twoMonthsInAdvance
        return twoMonthsInAdvance
    }
    
    func headerString(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter.string(from: date).capitalized
    }
}

extension MainViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
    }

    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "dd.MM.YYYY"
        viewModel.date.onNext(dateFormatter.string(from: date))
        dateTextField.text = dateFormatter.string(from: date)
    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return date >= startCalendarDate && date <= endCalendarDate
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
    }

    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
    }
}
