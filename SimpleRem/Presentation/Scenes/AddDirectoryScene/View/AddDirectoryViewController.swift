//
//  AddDirectoryViewController.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class AddDirectoryViewController: UIViewController {

    @IBOutlet weak var directoryNameTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addDirectory(_ sender: Any) {
        
        if directoryNameTextField.hasText {
            tryCreateDirectory()
        } else {
            showAlert(with: "Please enter category.")
        }
        
    }
    
    private func tryCreateDirectory() {
        do {
            try NotesManager.shared.createDirectory(directoryName: directoryNameTextField.text!)
            self.navigationController?.popViewController(animated: true)
        } catch FileErrors.badFileUrl {
            showAlert(with: "Unknown error, while creating directory, please try again.")
        } catch {
            showAlert(with: "Unknown error. Please try again.")
        }
    }
   
    private func showAlert(with message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
