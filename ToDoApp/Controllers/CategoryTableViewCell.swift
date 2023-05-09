//
//  CategoryTableViewCell.swift
//  ToDoApp
//
//  Created by Fenil Bhanavadiya on 2023-05-08.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
