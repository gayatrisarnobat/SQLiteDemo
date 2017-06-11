//
//  PersonTableCell.swift
//  SQLiteDemo
//
//  Created by Gayatri Sarnobat on 11/06/17.
//  Copyright © 2017 Gayatri Sarnobat. All rights reserved.
//

import UIKit

class PersonTableCell: UITableViewCell {

    @IBOutlet var lblPersonName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
