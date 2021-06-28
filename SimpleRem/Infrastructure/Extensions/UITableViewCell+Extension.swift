//
//  UITableViewCell+Extension.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    
    static var nib: UINib { UINib(nibName: identifier, bundle: Bundle.main) }
}
