//
//  PopUpViewVC.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/12/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

class PopUpViewVC: UIViewController {

    var newListName = myLists[selectedList]
    
    
    @IBOutlet weak var textBox: UITextField!
    
    
    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        textBox.text = newListName
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func showAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations:  {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func removeAnimate()
    {
        newListName = textBox.text!
        myLists[selectedList] = newListName
        
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["myLists"] = myLists
            
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
            } catch {
                print(error)
            }
            
        } else {
            print("Unable to get Plist")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0
        }, completion:{(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }

}
