//
//  TimeCircuitsViewController.swift
//  OuttaTime
//
//  Created by Marc Jacques on 3/13/21.
//

import UIKit

class TimeCircuitsViewController: UIViewController, TimeTravelDelegate {

    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var presentDateLabel: UILabel!
    @IBOutlet weak var lastTimeDepartedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    private var dateFormatter: DateFormatter {
          let formatter = DateFormatter()
          formatter.dateFormat = "MMM dd, yyyy"
          return formatter
      }
    
    let rulesOfTimeTravel = TimeTravel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
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
        speedLabel.text = "\(rulesOfTimeTravel.mph) MPH"
        lastTimeDepartedLabel.text = "___ __ ____"
        presentDateLabel.text = dateFormatter.string(from: Date())
        
    }
}
        
        @objc func updateLabels() {
            
            let alert = UIAlertController(title: "Time Travel Successful", message: "You're new date is \(destinationLabel.text ?? "default Value").", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            presentTimeLabel.text = "\(destinationLabel.text ?? "default Value")"
            
            present(alert, animated: true, completion: nil)
        }
    
    private func updateTimer(timer: Timer) {
        
        if let stopDate = rulesOfTimeTravel.travelDestination {
            if rulesOfTimeTravel.presentDate > stopDate {
                // Timer is active, keep counting down
                delegate?.countdownDidUpdate(timeRemaining: timeRemaining)
            } else {
                // Timer is finished, reset and stop counting down
                state = .finished
                cancelTimer()
                self.stopDate = nil
                delegate?.countdownDidFinish()
            }
    }
      
    @IBAction func setDestinationTapped(_ sender: UIButton) {
    }
    
    @IBAction func travelBackTapped(_ sender: UIButton) {
        rulesOfTimeTravel.startTimer()
        let alert = UIAlertController(title: "Time Travel Successful", message: "You're new date is \(destinationLabel.text ?? "default Value").", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        presentTimeLabel.text = "\(destinationLabel.text ?? "default Value")"
        
        present(alert, animated: true, completion: nil)
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        if segue.identifier == "DestinationModalSegue" {
            guard let datepickerVC = segue.destination as? DatePickerViewController else { return }
            datepickerVC.delegate = self
        }
        // Pass the selected object to the new view controller.
    }
 

}

extension TimeCircuitsViewController: DatePickerDelegate {
    
    func destinationDateWasChosen(date: Date) {
        
        destinationLabel.text = dateFormatter.string(for: date)
        updateViews()
        
    }
}
