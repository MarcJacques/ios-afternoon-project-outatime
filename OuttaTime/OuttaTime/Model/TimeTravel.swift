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

protocol TimeTravelDelegate: AnyObject {
    func dateDidUpdate(daysRemaining: DateInterval)
    func arrivedToDestination()
}

class TimeTravel {
    var presentDate: Date
    var travelDestination: Date? //we only have this after user enters date
   
    private var timer: Timer
    private(set) var state: TimeTravelState
    
    weak var delegate: TimeTravelDelegate?
    
    var mph: Int
    
    init() {
        timer = Timer()
        state = .reset
        mph = 0
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimeCircuitsViewController.updateLabels), userInfo: nil, repeats: true)
        
    }
   
    func resetTimer() {
        timer.invalidate()
        timer = Timer()
    }
    
    private func updateTimer(timer: Timer) {
        
        if let stopDate = travelDestination {
            let currentDate = Date()
            if currentDate <= stopDate {
                delegate?.dateDidUpdate(daysRemaining: daysRemaining)
            } else {
                state = .arrival
                cancelTimer()
                self.travelDestination = nil
                delegate?.arrivedToDestination()
            }
        }
    }
}
