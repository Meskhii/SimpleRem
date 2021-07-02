//
//  NotesDataSource.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class NotesDataSource: NSObject {
    
    // MARK: - Variables
    private var tableView: UITableView!
    private var viewModel: NotesViewModelProtocol!
    private var category: String!
    private var notes = [NoteModel]()
    
    // MARK: - Init
    init(with tableView: UITableView, viewModel: NotesViewModelProtocol, category: String) {
        super.init()
        
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel = viewModel
        self.category = category
    }
    
    func refresh() {
        do {
            notes = try viewModel.fetchNotes(for: category)
            tableView.reloadData()
        } catch {
            print("Unknow Error, while loading categories please try again.")
        }
    }

    
}

// MARK: - UITableView Data Source
extension NotesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(NoteCell.self, for: indexPath)
        cell.configure(with: notes[indexPath.row])
        return cell
    }
}

extension NotesDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        do {
            try NotesManager.shared.deleteNote(dir: category, noteName: notes[indexPath.row].noteTitle)
        } catch {
            print(error)
        }
        
        refresh()
    }
    
}
