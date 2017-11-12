//
//  MainViewController.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/4/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

// GLOBAL VARIABLES
var myLists = [String]()
var checkedBusinesses = [[Bool]]()
var BusinessList = [[[String]]]()

var selectedList = 0
var selectedDataArray: [[String]]! = [[String]]()

var myMutableString = NSMutableAttributedString()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    

    // DEFAULT METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //1
        if let plist = Plist(name: "data") {
            
            let dict = plist.getMutablePlistFile()!
            myLists = (dict.object(forKey: ("myLists")) as? [String])!
            BusinessList = (dict.object(forKey: ("BusinessList")) as? [[[String]]])!
            checkedBusinesses = (dict.object(forKey: ("checkedBusinesses")) as? [[Bool]])!
            favoritesList = (dict.object(forKey: ("favoritesList")) as? [[String]])!
            
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
            } catch {
                print(error)
            }

        } else {
            print("Unable to get Plist")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func loadList(notification: NSNotification){
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // TABLE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        var locations = BusinessList[indexPath.row]
        var location = locations[0][2]
        var listName = myLists[indexPath.row]
        var finalListName = "\(listName) (\(location))"
        
        myMutableString = NSMutableAttributedString(string: finalListName, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 17.0)!])
        
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 11.0)!, range: NSRange(location:listName.characters.count + 1,length:location.characters.count + 2))

        cell.lbl_ListName.text = "\(myLists[indexPath.row])  (\(location))"
        cell.lbl_ListName.attributedText = myMutableString
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = indexPath.row
        selectedDataArray.removeAll()
        selectedDataArray = BusinessList[selectedList]
        performSegue(withIdentifier: "goToList", sender: self)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            print("Deleting Cell")
//            BusinessList.remove(at: indexPath.row)
//            checkedBusinesses.remove(at: indexPath.row)
//            myLists.remove(at: indexPath.row)
//
//            
//            if let plist = Plist(name: "data") {
//                plist.saveFile()
//            } else {
//                print("Unable to get Plist")
//            }
//            
//            tableView.reloadData()
//        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "      ") {action in
            //handle delete
            print("Deleting Cell")
            BusinessList.remove(at: indexPath.row)
            checkedBusinesses.remove(at: indexPath.row)
            myLists.remove(at: indexPath.row)
            
            if let plist = Plist(name: "data") {
                plist.saveFile()
            } else {
                print("Unable to get Plist")
            }
            
            tableView.reloadData()
        }
        
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {action in
            //handle edit
            print("Editing Item")
            selectedList = indexPath.row
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuPopUp") as! PopUpViewVC
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
            
        }
        
        if let deleteImage = UIImage(named: "trash"){
            deleteAction.backgroundColor = UIColor(patternImage: deleteImage)
        }
        
        return [deleteAction, editAction]
    }


}

