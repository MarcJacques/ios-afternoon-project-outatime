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

protocol DateUpdatedDelegate {
    func presentHasBeenUpdated()
    func finishedUpdatingPresent()
}

struct TimeTravelDateLogic {
//    var months: [Int]
//    var monthString: Months.RawValue
//    var days: [String] = Array(1...31).map { String($0) }
//    var year: Int
    
//    var delegate: DateUpdatedDelegate?
    
//    var realCurrentDate: Date
    var presentDate: Date
    var destinationDate: Date
    
    func destinationDateMath(destinationDate: Date?, presentDate: Date?) {
        guard let date1 = destinationDate,
              let date2 = presentDate else { return }
        
        let destination = dateToIntegerArray(date: date1)
        let present = dateToIntegerArray(date: date2)
        var updatingPresent: [Int] = []
        
        if present[2] != destination[2] {
            updatingPresent = yearMath(destination: destination, present: present)
        }
        
        if updatingPresent[0] != destination[0] {
            updatingPresent[0] = monthMath(destination: destination[0], present: updatingPresent[0])
        }
        
        if updatingPresent[1] != destination[2] {
            updatingPresent[1] = dayMath(present: updatingPresent[1], destination: destination[2])
        }
    }
    
    private func dayMath(present: Int, destination: Int)-> Int {
        var dayTracker = present
        
        if dayTracker != destination {
            if dayTracker == 1 {
                dayTracker = 31
            } else if dayTracker <= 31 {
                dayTracker -= 1
            }
            #warning("updatePresentLabel use protocol")
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
            #warning("update presentLabel use protocol")
            return monthMath(destination: destination, present: monthTracker)
        }
        
        return monthTracker
    }
    
    
    private mutating func updatePresent(present: [Int]) {
        var components = DateComponents()
        components.year = present[2]
        components.month = present[0]
        components.day = present[1]
        guard let newDate = Calendar.current.date(from: components) else { return  }
        presentDate = newDate
    }
    
    private func yearMath(destination: [Int], present: [Int]) -> [Int] {
        var yearTracker = present
        if destination[2] < present[2] {
            yearTracker[2] -= 1
            #warning("update present label, use protocol")
            return yearMath(destination: destination, present: yearTracker)
        } else {
            return yearTracker
        }
    }
    
    
    func dateToIntegerArray(date: Date) -> [Int] {
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

