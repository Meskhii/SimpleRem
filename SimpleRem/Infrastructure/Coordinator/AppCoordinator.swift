//
//  AppCoordinator.swift
//  SimpleRem
//
//  Created by user200328 on 7/2/21.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
   
    // MARK: - Variables
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    // MARK: - Initialisation
    init(_ window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
        
    }
    
    // MARK: - Startup page
    func start() {
        let vc = DirectoriesViewController.instantiateFromStoryboard()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    func navigateToAddDirectory() {
        let vc = AddDirectoryViewController.instantiateFromStoryboard()
        vc.coordinator = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToNotes(categories: String) {
        let vc = NotesViewController.instantiateFromStoryboard()
        vc.coordinator = self
        vc.directory = categories
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddNote(directory: String) {
        let vc = AddNoteViewController.instantiateFromStoryboard()
        vc.coordinator = self
        vc.directory = directory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    func showAlert(with message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
}
