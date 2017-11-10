//
//  SecondViewController.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/4/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

var favoritesList = [[String]]()
var favoriteBusinesses = [[Bool]]()

class Favorites_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
    }
    
    func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
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
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        cell.lbl_Name.text = favoritesList[indexPath.row][0]
        //cell.btn_Edit.accessibilityLabel = String(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "    ") {action in
            //handle delete
            print("Deleting Cell")
            favoritesList.remove(at: indexPath.row)
            
            if let plist = Plist(name: "data") {
                plist.saveFile()
            } else {
                print("Unable to get Plist")
            }
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "    ") {action in
            //handle edit
            print("Opening Yelp")
            let businessUrl = self.makeURL(dataArray: favoritesList[indexPath.row][1])
            let url = NSURL(string: businessUrl)!
            UIApplication.shared.openURL(url as URL)
            
        }
        
        if let deleteImage = UIImage(named: "trash_small"){
            deleteAction.backgroundColor = UIColor(patternImage: deleteImage)
        }

        
        if let editImage = UIImage(named: "info"){
            editAction.backgroundColor = UIColor(patternImage: editImage)
        }
        
        return [deleteAction, editAction]
    }

    func makeURL(dataArray: String) -> String {
        var businessUrl = dataArray
        let startIndex = businessUrl.index(businessUrl.startIndex, offsetBy: 9)
        let endIndex = businessUrl.index(businessUrl.endIndex, offsetBy: -1)
        businessUrl = businessUrl.substring(to: endIndex)
        businessUrl = businessUrl.substring(from: startIndex)
        return businessUrl
    }

}

