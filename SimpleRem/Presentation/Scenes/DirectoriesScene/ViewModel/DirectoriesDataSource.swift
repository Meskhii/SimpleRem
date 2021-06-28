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
    private var navController: UINavigationController!
    private var categories = [String]()
    
    // MARK: - Init
    init(with tableView: UITableView, viewModel: DirectoriesViewModelProtocol, navController: UINavigationController) {
        super.init()
        
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel = viewModel
        self.navController = navController

    }
    
    func refresh() {
        do {
            categories = try viewModel.fetchDirectories()
            tableView.reloadData()
        } catch {
            if !categories.isEmpty {
                showAlert(with: "Unknow Error, while loading categories please try again.")
            }
        }
    }
    
    func createReminder(dirName: String, noteName: String, noteTime: Date) {
        do {
           try viewModel.createDirectory(dirName: dirName)
        } catch FileErrors.badFileUrl {
            showAlert(with: "Category Error, please try again.")
        } catch {
            showAlert(with: "Unknown Error, please try again.")
        }
        
        do {
           try viewModel.createNote(inDirectory: dirName, noteName: noteName, noteTime: noteTime)
        } catch FileErrors.fileAlreadyExists {
            showAlert(with: "Note already exists.")
        } catch {
            showAlert(with: "Unknown Error, please try again.")
        }
        
        refresh()
    }

    private func showAlert(with message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        navController.present(alert, animated: true, completion: nil)
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
        let sb = UIStoryboard(name: "NotesViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        vc.directory = categories[indexPath.row]
        navController.pushViewController(vc, animated: true)
    }
}
