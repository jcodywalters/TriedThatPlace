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

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    

    // DEFAULT METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
        cell.lbl_ListName.text = myLists[indexPath.row]
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
        if (editingStyle == UITableViewCellEditingStyle.delete) {
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
    }
}

