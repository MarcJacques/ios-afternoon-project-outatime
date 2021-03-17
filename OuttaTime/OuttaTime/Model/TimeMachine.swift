//
//  TimeTravel.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/13/21.
//

import Foundation

class TimeMachine: TimeTravelLogic {
    
    var presentDate: Date
    var travelDestination: Date? //we only have this after user enters date
    var duration: DateComponents
    var lastTimeDeparted: [String]
    
    private var timer: Timer?
    var state: TimeMachineState
    private(set) var timeLocation: TimeLocation
    
    var mph: Int
    var mphString: String
    
    override init() {
        lastTimeDeparted = []
        presentDate = Date()
        duration = DateComponents()
        timer = nil
        state = .off
        timeLocation = .present
        mph = 0
        mphString = "\(mph) MPH"
    }
    
    func presentDayLogic() {
        switch timeLocation {
        case .past:
            guard let presentString = lastTimeDeparted.last else { return }
                  let present = stringToDate(dateString: presentString)
            presentDate = present
        case .lostInTime:
            print("Something must be wrong with the Flux Capacitor!")
        default:
            presentDate = Date()
        }
    }
   
    func calculateDuration() -> DateComponents {
        guard let destination = travelDestination else { return DateComponents() }
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        guard let totalDuration = calendar?.components(.day,
                                                       from: presentDate,
                                                       to: destination,
                                                       options: .wrapComponents) else { return DateComponents() }
        return totalDuration
    }
    
    func createCalendarComponents() -> DateComponents {
        let myCalendar = Calendar.init(identifier: .gregorian)
        return myCalendar.dateComponents([.year, .month, .day], from: presentDate)
    }
    
    func timeMachine() {
        
        switch state {
        case .rampUp:
            lastTimeDeparted.append(dateToString(date: presentDate))
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(updateSpeed),
                                         userInfo: nil,
                                         repeats: true)
            
        case .timeTravel:
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(updatePresentDate),
                                         userInfo: nil, repeats: true)
        
        case .arrival:
            self.delegate?.arrivedToDestination()
            state = .off
        
        default:
            resetTimer()
            
        }
    }
    
    @objc func updateSpeed() {
        if mph < 88 {
            mph += 1
            delegate?.speedDidUpdate()
        } else if mph == 88 {
            resetTimer()
            state = .timeTravel
            timeMachine()
        }
    }
    
    @objc func updatePresentDate() {
        guard let destination = travelDestination else { return }
        
        if presentDate != destination {
            presentDate = self.destinationDateMath(destinationDate: destination, presentDate: presentDate)
        } else if presentDate == travelDestination {
            state = .arrival
            timeMachine()
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

