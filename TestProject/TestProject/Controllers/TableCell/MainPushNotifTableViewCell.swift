//
//  MainPushNotifTableViewCell.swift
//  TestProject
//
//  Created by Samir Deraiya on 23/03/23.
//

import UIKit

class MainPushNotifTableViewCell: UITableViewCell {
    
    // Outlets -
    @IBOutlet weak var desclabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var timer: Timer?
    var timerStarted: Bool = false
    var timerData: NotificationModel?
    
    // Nib Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func startTimerIfNeeded(completion: ((UUID) -> Void)?) {
        guard let timerData = timerData else { return }
        
        if !timerStarted {
            timerStarted = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                let now = Date()
                let elapsedTime = now.timeIntervalSince(timerData.startTime)
                let remainingTime = max(timerData.timeInterval - elapsedTime, 0)
                let timeString = self.formatTimeInterval(remainingTime)
                self.countDownLabel.text = timeString
                
                if remainingTime <= 0 {
                    self.stopTimer()
                    
                    if let completion = completion {
                        completion(timerData.id)
                    }
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerStarted = false
    }
    
    // To format time interval
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval)!
    }
}
