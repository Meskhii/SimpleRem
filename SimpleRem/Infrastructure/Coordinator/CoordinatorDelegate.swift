//
//  CoordinatorDelegate.swift
//  SimpleRem
//
//  Created by user200328 on 7/2/21.
//

import UIKit

protocol CoordinatorDelegate: UIViewController {
    var coordinator: CoordinatorProtocol? { get set }
}
