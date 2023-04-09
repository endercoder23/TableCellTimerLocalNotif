//
//  CreatePushNotifViewController.swift
//  TestProject
//
//  Created by Samir Deraiya on 23/03/23.
//

import UIKit

protocol SaveNotificationDelegate: AnyObject {
    func saveNotificationData(notifInfo: NotificationModel)
}

class CreatePushNotifViewController: UIViewController {
    
    // Outlets -
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timeTextfield: UITextField!
    {
        didSet {
            timeTextfield.layer.borderWidth = 1
            timeTextfield.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var descriptionTextview: UITextView! {
        didSet {
            descriptionTextview.layer.borderWidth = 1
            descriptionTextview.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var titleTextfield: UITextField!{
        didSet {
            titleTextfield.layer.borderWidth = 1
            titleTextfield.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    // Declared variables -
    weak var delegate: SaveNotificationDelegate?
    let datePicker = UIDatePicker()

    
    
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePickerInput()
    }
    
    // Helper methods -
    private func setDatePickerInput() {
        timeTextfield.addInputViewDatePicker(target: self, selector: #selector(textfieldDoneButtonPressed))
    }
}


// Action Methods
extension CreatePushNotifViewController {
    
    @IBAction private func doneButtonPresses(_ sender: UIButton) {
        guard let timeinterval = self.timeTextfield.text?.convertToTimeInterval() else { return }
        let notifDetails = NotificationModel(id: UUID(), title: titleTextfield.text ?? "", description: descriptionTextview.text, timeInterval: timeinterval, startTime: Date())
        delegate?.saveNotificationData(notifInfo: notifDetails)
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func textfieldDoneButtonPressed() {
        if let  datePicker = self.timeTextfield.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            datePicker.datePickerMode = .countDownTimer
            dateFormatter.dateStyle = .short
            let time = datePicker.countDownDuration
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            let duration = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
            self.timeTextfield.text = duration
        }
        self.timeTextfield.resignFirstResponder()
    }
}
