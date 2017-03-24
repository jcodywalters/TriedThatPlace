//
//  ListCell.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/5/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

var businessCellIndexSelected = 0

class ListCell : UITableViewCell  {

    @IBOutlet weak var btn_CheckBox: UIButton!
    
    @IBOutlet weak var lbl_Name: UILabel!
    
    @IBOutlet weak var btn_Edit: UIButton!
    
    @IBAction func checkBoxSelected(_ sender: UIButton) {
        print("\(lbl_Name.text) + was checked")
        
        if sender.currentImage == UIImage(named:"checked") {

            sender.setImage( UIImage(named:"notChecked"), for: .normal)
            checkedBusinesses[selectedList][Int(sender.accessibilityLabel!)!] = false
            
            print("changed to notChecked")
        } else {
            sender.setImage(UIImage(named:"checked"), for: .normal)
            checkedBusinesses[selectedList][Int(sender.accessibilityLabel!)!] = true
            print("changed to checked")
        }
        
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["checkedBusinesses"] = checkedBusinesses
            
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
            } catch {
                print(error)
            }
            
        } else {
            print("Unable to get Plist")
        }
    }
    
    @IBAction func editBTNPressed(_ sender: UIButton) {
        businessCellIndexSelected = Int(sender.accessibilityLabel!)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
