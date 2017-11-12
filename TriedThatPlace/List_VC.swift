//
//  List_VC.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/5/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit

class List_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lbl_ListName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_Location: UILabel!
    
    
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuPopUp") as! PopUpViewVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = myLists[selectedList]
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]
        lbl_Location.text = "Location: \(selectedDataArray[0][2])"
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func loadList(notification: NSNotification){
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // TABLE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        cell.lbl_Name.text = selectedDataArray[indexPath.row][0]
        let url = makeURL(dataArray: selectedDataArray[indexPath.row][3])
        cell.ratingImage.setImageWith(NSURL(string: url) as! URL)
        cell.btn_CheckBox.accessibilityLabel = String(indexPath.row)
        
        if checkedBusinesses[selectedList][indexPath.row] {
            cell.btn_CheckBox.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            cell.btn_CheckBox.setImage(#imageLiteral(resourceName: "notChecked"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "    ") {action in
            //handle delete
                print("Deleting Cell")
                BusinessList[selectedList].remove(at: indexPath.row)
                selectedDataArray.remove(at: indexPath.row)
                checkedBusinesses[selectedList].remove(at: indexPath.row)
                
                if let plist = Plist(name: "data") {
                    plist.saveFile()
                } else {
                    print("Unable to get Plist")
                }
                
                tableView.reloadData()
            }
        
        
        let starAction = UITableViewRowAction(style: .normal, title: "    ") {action in
            //handle edit
            print("Favorited Item")
            favoritesList.append([selectedDataArray[indexPath.row][0], selectedDataArray[indexPath.row][1]])
            
            if let plist = Plist(name: "data") {
                plist.saveFile()
            } else {
                print("Unable to get Plist")
            }
        }
         
        let editAction = UITableViewRowAction(style: .normal, title: "    ") {action in
            //handle edit
            print("Opening Yelp")
            let businessUrl = self.makeURL(dataArray: selectedDataArray[indexPath.row][1])
            let url = NSURL(string: businessUrl)!
            UIApplication.shared.openURL(url as URL)

        }
        
        if let deleteImage = UIImage(named: "trash_small"){
            deleteAction.backgroundColor = UIColor(patternImage: deleteImage)
            
        }
        
        if let starImage = UIImage(named: "star_notChecked"){
            starAction.backgroundColor = UIColor(patternImage: starImage)
        }
        
        if let editImage = UIImage(named: "yelp_icon"){
            editAction.backgroundColor = UIColor(patternImage: editImage)
        }
        
        return [deleteAction, starAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

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
