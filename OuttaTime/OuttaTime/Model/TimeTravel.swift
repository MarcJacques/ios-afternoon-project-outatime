//
//  TimeLogic.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/19/21.
//

import Foundation

protocol TimeLogicDelegate: AnyObject {
    func speedDidUpdate()
    
}

class TimeTravel {
    
    var destination: Date?
    var present: Date
    var lastTimeDeparted: [Date]
    
    var timer: Timer
    
    var delegate: TimeLogicDelegate?
    
    init() {
        present = Date()
        timer = Timer()
       
        lastTimeDeparted = []
    }
    
    
    
}
