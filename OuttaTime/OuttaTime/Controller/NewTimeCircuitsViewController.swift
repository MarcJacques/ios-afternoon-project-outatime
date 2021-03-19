//
//  NewTimeCircuitsViewController.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/19/21.
//

import UIKit

enum State {
    case off
    case destinationSet
    case timeTravel
    case arrived
    case past
    case present
}

class NewTimeCircuitsViewController: UIViewController {
    
    //     MARK: - Properties & Views
    var timeLogic = TimeTravel()
    var speed = 0
    var state: State = .off
    
    var destinationString = "--- -- ----"
    var lastTimeDepartedString = "--- -- ----"
    var speedString = ""
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var presentDateLabel: UILabel!
    @IBOutlet weak var lastTimeDepartedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLogic.delegate = self
        updateViews()
        
    }
    //    MARK: - Methods
    
    func updateViews() {
        speedString = "\(speed) MPH"
        
        destinationLabel.text = destinationString
        presentDateLabel.text = presentDay()
        lastTimeDepartedLabel.text = lastTimeDepartedString
        speedLabel.text = speedString
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date)
    }
    
    func presentDay() -> String {
        switch state {
        case .past:
            guard let last = timeLogic.lastTimeDeparted.last else { return "--- -- ----" }
            return dateToString(date: last)
        default:
            return dateToString(date: Date())
        }
    }
    
    func speedCheck() {
        if speed != 88 {
            speed += 1
            updateViews()
        } else {
            state = .timeTravel
            //            timeLogic.startTimeTravel()
            
        }
    }
    
    
    @IBAction func travelBackTapped(_ sender: UIButton) {
        timeLogic.startTimeTravel()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DestinationModalSegue" {
            guard let datepickerVC = segue.destination as? DatePickerViewController else { return }
            datepickerVC.delegate = self
        }
    }
}

extension NewTimeCircuitsViewController: TimeLogicDelegate {
    
    func getUpToSpeed() {
        speedCheck()
    }
    
    
}

extension NewTimeCircuitsViewController: DatePickerDelegate {
    
    func destinationSet(destination: Date) {
        destinationString = dateToString(date: destination)
        state = .destinationSet
        updateViews()
    }
    
}

