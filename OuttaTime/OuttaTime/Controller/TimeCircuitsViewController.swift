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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
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
        lastTimeDepartedLabel.text = "--- -- ----"
        presentDateLabel.text = dateFormatter.string(from: Date())
        updateDestinationLabel()
    }
    
    private func updateDestinationLabel() {
            if let destination = rulesOfTimeTravel.travelDestination {
            destinationLabel.text = dateFormatter.string(from: destination)
            } else {
            destinationLabel.text = "--- -- ----"
        }
    }
    
       
        @IBAction func setDestinationTapped(_ sender: UIButton) {
            
        }
        
        @IBAction func travelBackTapped(_ sender: UIButton) {
            rulesOfTimeTravel.travelBackInTime()
            
        }
        
        
        
        // MARK: - Navigation
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "DestinationModalSegue" {
                guard let datepickerVC = segue.destination as? DatePickerViewController else { return }
                datepickerVC.delegate = self
            }
            // Pass the selected object to the new view controller.
        }
        
        
    }
extension TimeCircuitsViewController: TimeTravelDelegate {
    func speedDidUpdate() {
        speedLabel.text = rulesOfTimeTravel.mphString
    }
    
    func dateDidUpdate() {
        presentDateLabel.text = dateFormatter.string(from: rulesOfTimeTravel.presentDate)
    }
    
    func arrivedToDestination(){
        showAlert()
    }
}

extension TimeCircuitsViewController: DatePickerDelegate, UIPickerViewDelegate {
    
    func destinationDateWasChosen(date: Date) {
        rulesOfTimeTravel.travelDestination = date
        updateViews()
    }
}
