//
//  AddNoteViewController.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class AddNoteViewController: BaseViewController {
    
    var directory: String?

    @IBOutlet weak var noteTitleLabel: UITextField!
    @IBOutlet weak var noteTimeDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func addNote(_ sender: Any) {
        if checkInputs() {
            trySaveNote()
        } else {
            coordinator!.showAlert(with: "Unknown Error, please try again.")
        }
    }
    
    private func trySaveNote() {
        guard let dir = directory else {return}
        do {
            try NotesManager.shared.createNote(inDirectory: dir, noteName: noteTitleLabel.text!, noteTime: noteTimeDatePicker.date)
            self.navigationController?.popViewController(animated: true)
        } catch FileErrors.fileAlreadyExists{
            coordinator!.showAlert(with: "Note already exists.")
        } catch {
            coordinator!.showAlert(with: "Unknown Error, please try again.")
        }
    }
    
    private func checkInputs() -> Bool {
        if noteTitleLabel.hasText {
            return true
        } else {
            return false
        }
    }
    
}
