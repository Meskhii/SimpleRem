//
//  AddDirectoryViewController.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class AddDirectoryViewController: BaseViewController {

    @IBOutlet weak var directoryNameTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addDirectory(_ sender: Any) {
        
        if directoryNameTextField.hasText {
            tryCreateDirectory()
        } else {
            coordinator!.showAlert(with: "Please enter category.")
        }
        
    }
    
    private func tryCreateDirectory() {
        do {
            try NotesManager.shared.createDirectory(directoryName: directoryNameTextField.text!)
            self.navigationController?.popViewController(animated: true)
        } catch FileErrors.badFileUrl {
            coordinator!.showAlert(with: "Unknown error, while creating directory, please try again.")
        } catch {
            coordinator!.showAlert(with: "Unknown error. Please try again.")
        }
    }
    
}
