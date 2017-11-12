//
//  CustomCell.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/5/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var lbl_ListName: UILabel!
    
    
    @IBOutlet weak var img_forward: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
