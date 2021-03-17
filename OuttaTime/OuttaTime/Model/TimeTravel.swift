//
//  TimeTravel.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/13/21.
//

import Foundation

enum TimeTravelState {
    case rampUp
    case timeTravel
    case arrival
    case reset
}

enum TimeLocation {
    case present
    case past
}

protocol TimeTravelDelegate: AnyObject {
    func speedDidUpdate()
    func dateDidUpdate()
    func arrivedToDestination()
    
}

class TimeTravel {
    var presentDate: Date
    var travelDestination: Date? //we only have this after user enters date
    var duration: DateComponents
   
    private var timer: Timer
    private(set) var state: TimeTravelState
    private(set) var timeLocation: TimeLocation
    
    weak var delegate: TimeTravelDelegate?
    var dateLogic: TimeTravelDateLogic?
    var mph: Int
    var mphString: String
    
    init() {
        presentDate = Date()
        duration = DateComponents()
        timer = Timer()
        state = .reset
        timeLocation = .present
        mph = 0
        mphString = "\(mph) MPH"
        
    }
    
    func calculateDuration() -> DateComponents {
        guard let destination = travelDestination else { return DateComponents() }
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        guard let totalDuration = calendar?.components(.day, from: presentDate, to: destination, options: .wrapComponents) else { return DateComponents() }
        
        return totalDuration
    }
    
    func createCalendarComponents() -> DateComponents {
        let myCalendar = Calendar.init(identifier: .gregorian)
         return myCalendar.dateComponents([.year, .month, .day], from: presentDate)
    }
    
    func travelBackInTime() {
        rampUpTimer()
        guard let destination = travelDestination else { return }
        dateLogic = TimeTravelDateLogic(presentDate: presentDate, destinationDate: destination)
        
    }
    
    private func rampUpTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateSpeed() {
        if mph < 88 {
        mph += 1
        delegate?.speedDidUpdate()
        } else if mph == 88 {
            state = .timeTravel
            resetTimer()
        }
    }
    
    private func dateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePresentDate), userInfo: nil, repeats: true)
    }
    
    @objc func updatePresentDate() {
        if presentDate != travelDestination {
            
        }
        
    }
   
    private func resetTimer() {
        timer.invalidate()
        timer = Timer()
    }
    
}

