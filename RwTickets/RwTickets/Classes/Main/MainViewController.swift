//
//  ViewController.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/7/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import KDCalendar

class MainViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var dateTextField: UITextField!
    
    var viewModel: MainViewModel!
    var startCalendarDate: Date!
    var endCalendarDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.multipleSelectionEnable = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    /* optional */
    //    func calendar(_ calendar : CalendarView, canSelectDate date : Date) -> Bool
    //    func calendar(_ calendar : CalendarView, didDeselectDate date : Date) -> Void
    //    func calendar(_ calendar : CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) -> Void
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        self.dateTextField.text = dateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return date >= startCalendarDate && date <= endCalendarDate
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
}
