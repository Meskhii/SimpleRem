//
//  NotesViewController.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class NotesViewController: UIViewController {
    
    private var viewModel: NotesViewModel!
    private var notesDataSource: NotesDataSource!
    var directory = String()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(class: NoteCell.self)
        configureViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notesDataSource.refresh()
    }
    
    private func configureViewModel() {
        viewModel = NotesViewModel()
        notesDataSource = NotesDataSource(with: tableView, viewModel: viewModel, category: directory)
        
        notesDataSource.refresh()
    }
    
    
    @IBAction func addNote(_ sender: Any) {
        let sb = UIStoryboard(name: "AddNoteViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        vc.directory = directory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func editNotes(_ sender: Any) {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    @IBAction func returnToCategories(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
