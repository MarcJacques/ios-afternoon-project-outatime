//
//  TimeCircuitsViewController.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/13/21.
//

import UIKit

class TimeCircuitsViewController: UIViewController {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var presentDateLabel: UILabel!
    @IBOutlet weak var lastTimeDepartedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
  
    let timeTravel = TimeMachine()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        timeTravel.delegate = self
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Time Travel Successful",
                                      message: "Your new date is \(String(describing: presentDateLabel.text))",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func updateViews() {
        switch timeTravel.state {
        case .rampUp:
            speedLabel.text = mphString()
        case .timeTravel:
            presentDateLabel.text = timeTravel.dateToString(date: timeTravel.presentDate)
        case .arrival:
            presentDateLabel.text = timeTravel.dateToString(date: timeTravel.presentDate)
            lastTimeDepartedLabel.text = timeTravel.lastTimeDepartedString
        default:
            presentDateLabel.text = timeTravel.dateToString(date: timeTravel.presentDate)
            speedLabel.text = "\(timeTravel.mph) MPH"
            if let destination = timeTravel.travelDestination {
                destinationLabel.text = timeTravel.dateToString(date: destination)
            } else {
                destinationLabel.text = "--- -- ----"
            }
        }
    }
    
    func mphString() -> String {
        return "\(timeTravel.mph) MPH"
    }
    
    @IBAction func setDestinationTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func travelBackTapped(_ sender: UIButton) {

        timeTravel.timeMachine()
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DestinationModalSegue" {
            guard let datepickerVC = segue.destination as? DatePickerViewController else { return }
//            datepickerVC.delegate = self
        }
        // Pass the selected object to the new view controller.
    }
    
    
}

extension TimeCircuitsViewController: TimeTravelDelegate {
    func speedDidUpdate(speed: Int) {
        
        updateViews()
    }
    
    func updatingPresent() {
        updateViews()
    }
    
    func arrivedToDestination() {
        timeTravel.presentDayLogic()
        updateViews()
        showAlert()
        
    }
}

//extension TimeCircuitsViewController: DatePickerDelegate {
//
//    func destinationDateWasChosen(date: Date) {
//        timeTravel.travelDestination = date
//        updateViews()
//    }
//}
