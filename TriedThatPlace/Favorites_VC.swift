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
    
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuPopUp") as! PopUpViewVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        cell.btn_Edit.accessibilityLabel = String(indexPath.row)
        cell.btn_CheckBox.accessibilityLabel = String(indexPath.row)

        return cell
    }
    

}

