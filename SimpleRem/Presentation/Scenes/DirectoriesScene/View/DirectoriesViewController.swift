//
//  ViewController.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UserNotifications
import UIKit

class DirectoriesViewController: UIViewController {
    
    private var directoriesDataSource: DirectoriesDataSource!
    private var viewModel: DirectoriesViewModelProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(class: DirectoryCell.self)
        configureViewModel()
        
        userNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        directoriesDataSource.refresh()
    }
    
    private func configureViewModel() {
        viewModel = DirectoriesViewModel()
        directoriesDataSource = DirectoriesDataSource(with: tableView, viewModel: viewModel, navController: self.navigationController!)
        
        directoriesDataSource.refresh()
    }
    
    private func userNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                self.scheduleNotifications()
            } else {
                
            }
        })
    }
    
    private func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's Reminder Notification"
        content.sound = .default
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification_id", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print(error!)
            }
        })
    }
    
    
    @IBAction func addDirectory(_ sender: Any) {
        let sb = UIStoryboard(name: "AddDirectoryViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddDirectoryViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func RemindMeDirectories(_ sender: Any) {
        
        promptForNote()
        
    }
    
    func promptForNote() {
        let ac = UIAlertController(title: "Create Reminder", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Category"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Reminder Name"
        }
        
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        ac.view.addSubview(picker)
        ac.view.heightAnchor.constraint(equalToConstant: 260).isActive = true
        picker.leadingAnchor.constraint(equalTo: ac.view.leadingAnchor, constant: 20).isActive = true
        picker.trailingAnchor.constraint(equalTo: ac.view.trailingAnchor, constant: -20).isActive = true
        picker.bottomAnchor.constraint(equalTo: ac.view.bottomAnchor, constant: -80).isActive = true
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            
            if ac.textFields![0].hasText && ac.textFields![1].hasText {
                let dirName = ac.textFields![0].text!
                let noteName = ac.textFields![1].text!
                let noteTime = picker.date
                self.directoriesDataSource.createReminder(dirName: dirName, noteName: noteName, noteTime: noteTime)
            } else {
                self.showAlert(with: "Fill all fields.")
            }
            
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    private func showAlert(with message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

