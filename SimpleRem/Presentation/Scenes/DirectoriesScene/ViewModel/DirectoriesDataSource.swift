//
//  MainDataSource.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class DirectoriesDataSource: NSObject {
    
    // MARK: - Variables
    private var tableView: UITableView!
    private var viewModel: DirectoriesViewModelProtocol!
    private var coordinator: CoordinatorProtocol!
    private var navController: UINavigationController!
    private var categories = [String]()
    private var notes = [NoteModel]()
    
    // MARK: - Init
    init(with tableView: UITableView, viewModel: DirectoriesViewModelProtocol, navController: UINavigationController, coordinator: CoordinatorProtocol) {
        super.init()
        
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel = viewModel
        self.navController = navController

        self.coordinator = coordinator
    }
    
    func refresh() {
        do {
            categories = try viewModel.fetchDirectories()
            for category in categories {
                notes.append(contentsOf: try viewModel.fetchNotes(for: category))
            }
            
            tableView.reloadData()
        } catch {
            if !categories.isEmpty {
                coordinator.showAlert(with: "Unknow Error, while loading categories please try again.")
            }
        }
    }
    
    // MARK: - Creating Reminder Logic
    func createReminder(dirName: String, noteName: String, noteTime: Date) {
        do {
           try viewModel.createDirectory(dirName: dirName)
        } catch FileErrors.badFileUrl {
            coordinator.showAlert(with: "Category Error, please try again.")
        } catch {
            coordinator.showAlert(with: "Unknown Error, please try again.")
        }
        
        do {
           try viewModel.createNote(inDirectory: dirName, noteName: noteName, noteTime: noteTime)
        } catch FileErrors.fileAlreadyExists {
            coordinator.showAlert(with: "Note already exists.")
        } catch {
            coordinator.showAlert(with: "Unknown Error, please try again.")
        }
        
        scheduleNotifications(reminderName: noteName, reminderDate: noteTime)
        refresh()
    }
    
    // MARK: - Notifications Logic
    private func scheduleNotifications(reminderName: String, reminderDate: Date){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminderName
        content.sound = .default

        let interval = reminderDate - Date()
        let date = Date().addingTimeInterval(TimeInterval(interval.second!))
        
        let dateMatching = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, . second], from: date)
        let trigger = UNCalendarNotificationTrigger (dateMatching: dateMatching, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }

}

// MARK: - UITableView Data Source
extension DirectoriesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(DirectoryCell.self, for: indexPath)
        cell.configure(with: categories[indexPath.row])
        return cell
    }
}

extension DirectoriesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.navigateToNotes(categories: categories[indexPath.row])
    }
}
