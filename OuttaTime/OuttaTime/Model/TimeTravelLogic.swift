//
//  File.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/16/21.
//

import Foundation

enum Months: String, CaseIterable {
    case JAN
    case FEB
    case MAR
    case APR
    case MAY
    case JUN
    case JUL
    case AUG
    case SEP
    case OCT
    case NOV
    case DEC
}
enum TimeMachineState {
    case rampUp
    case timeTravel
    case arrival
    case off
}

enum TimeLocation {
    case present
    case past
    case lostInTime
}

protocol TimeTravelDelegate: AnyObject {
    func speedDidUpdate(speed: Int)
    func updatingPresent()
    func arrivedToDestination()
}

class TimeTravelLogic {

    weak var delegate: TimeTravelDelegate?
   

    func destinationDateMath(destinationDate: Date, presentDate: Date) -> Date {
        
        let destination = dateToIntegerArray(date: destinationDate)
        let present = dateToIntegerArray(date: presentDate)
        var updatingPresent: [Int] = []
        
        if present[2] != destination[2] {
            updatingPresent = yearMath(destination: destination, present: present)
        }
        
        if updatingPresent[0] != destination[0] {
            updatingPresent[0] = monthMath(destination: destination[0], present: updatingPresent[0])
        }
        
        if updatingPresent[1] != destination[1] {
            updatingPresent[1] = dayMath(present: updatingPresent[1], destination: destination[2])
        }
        return updatePresent(present: updatingPresent)
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        guard let date = formatter.date(from: dateString) else { return Date() }
        return date
    }
   
    private func dayMath(present: Int, destination: Int) -> Int {
        var dayTracker = present
        
        if dayTracker != destination {
            if dayTracker == 1 {
                dayTracker = 31
            } else if dayTracker <= 31 {
                dayTracker -= 1
            }
            delegate?.updatingPresent()
            return dayMath(present: dayTracker, destination: destination)
        }
        return dayTracker
    }
    
    private func monthMath(destination: Int, present: Int) -> Int {
        var monthTracker = present
        
        if monthTracker != destination {
            if monthTracker == 1 {
                monthTracker = 12
            } else if monthTracker <= 12 {
                monthTracker -= 1
            }
            delegate?.updatingPresent()
            return monthMath(destination: destination, present: monthTracker)
        }
        
        return monthTracker
    }
    
    
    private func updatePresent(present: [Int]) -> Date {
        var components = DateComponents()
        components.year = present[2]
        components.month = present[0]
        components.day = present[1]
        guard let newDate = Calendar.current.date(from: components) else { return Date() }
        return newDate
    }
    
    private func yearMath(destination: [Int], present: [Int]) -> [Int] {
        var yearTracker = present
        if destination[2] < present[2] {
            yearTracker[2] -= 1
            delegate?.updatingPresent()
            return yearMath(destination: destination, present: yearTracker)
        } else {
            return yearTracker
        }
    }
    
    
    private func dateToIntegerArray(date: Date) -> [Int] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        
        let dateArray = formatter.string(from: date).components(separatedBy: " ")
        
        var newDateArray: [Int] = []
        
        for element in dateArray {
            newDateArray.append(Int(element) ?? 0)
        }
        return newDateArray
    }
    
}

