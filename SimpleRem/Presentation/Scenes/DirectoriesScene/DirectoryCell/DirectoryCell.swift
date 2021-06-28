//
//  NoteCell.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class DirectoryCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with categoryName: String) {
        self.categoryName.text = categoryName
    }
    
}
