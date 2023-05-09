//
//  ToDoItemTableViewCell.swift
//  ToDoApp
//
//  Created by Fenil Bhanavadiya on 2023-01-05.
//

import UIKit

class ToDoTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
