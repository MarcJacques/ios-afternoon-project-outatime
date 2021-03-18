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
    var lastTimeDeparted: [String]?
    var lastTimeDepartedString: String
    
    private var timer: Timer?
    private(set) var state: TimeMachineState
    private(set) var timeLocation: TimeLocation
    
    var mph: Int
    
    override init() {
        lastTimeDeparted = []
        lastTimeDepartedString = "\(lastTimeDeparted?.last ?? "--- -- ----" )"
        presentDate = Date()
        duration = DateComponents()
        timer = nil
        state = .off
        timeLocation = .present
        mph = 0

    }
    
    func presentDayLogic() {
        switch timeLocation {
        case .past:
            let present = stringToDate(dateString: lastTimeDepartedString)
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
        case .off:
            self.state = .rampUp
        case .rampUp:
            lastTimeDeparted?.append(dateToString(date: presentDate))
            
            resetTimer()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                         repeats: true,
                                         block: updateSpeed(timer:))
            
        case .timeTravel:
            resetTimer()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                         repeats: true,
                                         block: updatePresentDate(timer:))
        
        case .arrival:
            state = .off
            resetTimer()
            mph = 0
            delegate?.speedDidUpdate(speed: mph)
            delegate?.arrivedToDestination()
    
        }
    }
    
    private func updateSpeed(timer: Timer) {
        mph += 1
        if mph == 88 {
            resetTimer()
            state = .timeTravel
            timeMachine()
        }
        delegate?.speedDidUpdate(speed: mph)
    }
    
    private func updatePresentDate(timer: Timer) {
        guard let destination = travelDestination else { return }
        
        if presentDate != destination {
            presentDate = destinationDateMath(destinationDate: destination, presentDate: presentDate)
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

