//
//  PopUpViewVC.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/12/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

class PopUpViewVC: UIViewController {

    @IBAction func starSelected(_ sender: UIButton) {
        favoritesList.append([selectedDataArray[businessCellIndexSelected][0], selectedDataArray[businessCellIndexSelected][1]])
        
        if let plist = Plist(name: "data") {
            plist.saveFile()
        } else {
            print("Unable to get Plist")
        }
    }
    
    @IBAction func infoSelected(_ sender: UIButton) {
        print(selectedDataArray)
        let businessUrl = makeURL(dataArray: selectedDataArray[businessCellIndexSelected][1])
        let url = NSURL(string: businessUrl)!
        UIApplication.shared.openURL(url as URL)
    }

    @IBAction func trashSelected(_ sender: Any) {
        BusinessList[selectedList].remove(at: businessCellIndexSelected)
        selectedDataArray.remove(at: businessCellIndexSelected)
        checkedBusinesses[selectedList].remove(at: businessCellIndexSelected)

        if let plist = Plist(name: "data") {
            plist.saveFile()
        } else {
            print("Unable to get Plist")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.removeAnimate()
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func makeURL(dataArray: String) -> String {
        var businessUrl = dataArray
        let startIndex = businessUrl.index(businessUrl.startIndex, offsetBy: 9)
        let endIndex = businessUrl.index(businessUrl.endIndex, offsetBy: -1)
        businessUrl = businessUrl.substring(to: endIndex)
        businessUrl = businessUrl.substring(from: startIndex)
        return businessUrl
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
