//
//  TimeLogic.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/19/21.
//

import Foundation

protocol TimeLogicDelegate: AnyObject {
    func getUpToSpeed()
    
}

class TimeTravel {
    
    var destination: Date?
    var present: Date
    var lastTimeDeparted: [Date]
    
    var timer: Timer?
    
    var delegate: TimeLogicDelegate?
    
    init() {
        present = Date()
        timer = nil
       
        lastTimeDeparted = []
    }
    
    func startTimeTravel() {
        resetTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                     repeats: true ) { timer in self.updateSpeed() }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateSpeed() {
        delegate?.getUpToSpeed()
    }
    
    
    
}
