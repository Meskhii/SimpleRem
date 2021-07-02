//
//  CoordinatorProtocol.swift
//  SimpleRem
//
//  Created by user200328 on 7/2/21.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
        
    init(_ window: UIWindow?, navigationController: UINavigationController?)
    
    func start()
    func popViewController()
    
    func navigateToAddDirectory()
    func navigateToNotes(categories: String)
    func navigateToAddNote(directory: String)
    
    func showAlert(with message: String)
}
