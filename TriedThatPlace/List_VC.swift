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
    
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuPopUp") as! PopUpViewVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tried That Place"
        lbl_ListName.text = myLists[selectedList]
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
        cell.btn_CheckBox.accessibilityLabel = String(indexPath.row)
        cell.btn_Edit.accessibilityLabel = String(indexPath.row)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
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
    }
}
