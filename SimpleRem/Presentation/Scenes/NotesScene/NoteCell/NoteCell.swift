//
//  NoteCell.swift
//  SimpleRem
//
//  Created by user200328 on 6/28/21.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteNameLabel: UILabel!
    
    @IBOutlet weak var noteDueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with note: NoteModel) {
        noteNameLabel.text = note.noteTitle
        noteDueDateLabel.text = note.noteDate
    }
    
}
