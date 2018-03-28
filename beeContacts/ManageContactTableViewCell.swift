//
//  ManageContactTableViewCell.swift
//  beeContacts
//
//  Created by Danil on 24/03/2018.
//  Copyright © 2018 Danil. All rights reserved.
//

import UIKit

class ManageContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldValue: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
