//
//  ViewController.swift
//  TestProject
//
//  Created by Samir Deraiya on 23/03/23.
//

import UIKit

class MainViewController: UIViewController {

    // Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    // Declared Variables
    let cellIdentifier = "MainPushNotifTableViewCell"
    var pushNotifArray = [NotificationModel]()
    
    // View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
    }
    
    // Helper methods
    private func setupTableview() {
        // Datasource and delegate are done through storyboard
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    // To trigger local notification
    private func triggerNotification(title: String, desc: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = desc
        content.sound = UNNotificationSound.default
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber;
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)

        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled successfully")
            }
        }
    }
    
}

// Action Methods -
extension MainViewController {
    @IBAction func addNotifPressed(_ sender: UIBarButtonItem) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreatePushNotifViewController") as? CreatePushNotifViewController else {return}
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// Table view delegate and datasource methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pushNotifArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainPushNotifTableViewCell else {return UITableViewCell()}
        
        let timerData = pushNotifArray[indexPath.row]
        cell.titlelabel.text = timerData.title
        cell.desclabel.text = timerData.description
        cell.timerData = timerData
        cell.startTimerIfNeeded {[weak self] id in
            guard let self = self else {return}
            let index = self.pushNotifArray.firstIndex(where: {$0.id == id})
            self.pushNotifArray.removeAll(where: {$0.id == id})
            self.tableView.deleteRows(at: [IndexPath(row: index ?? 0, section: 0)], with: .fade)
            self.triggerNotification(title: timerData.title, desc: timerData.description)
        }
        return cell
    }
}

// Delegate Method
extension MainViewController: SaveNotificationDelegate {
    func saveNotificationData(notifInfo: NotificationModel) {
        pushNotifArray.append(notifInfo)
        // whenever array populated reload table
        tableView.reloadData()
    }
}

