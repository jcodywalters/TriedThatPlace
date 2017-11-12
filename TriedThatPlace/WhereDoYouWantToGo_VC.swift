//
//  WhereDoYouWantToGo_VC.swift
//  TriedThatPlace
//
//  Created by Cody Walters on 3/5/17.
//  Copyright © 2017 Cody Walters. All rights reserved.
//

import UIKit
// Dismisses Keyboard when user taps anywhere
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class WhereDoYouWantToGo_VC: UIViewController {

    var businesses: [Business]!
    var listName = ""
    var searchText = ""
    var category = ""
    var location = ""
    var checkedBusinesssTemp = [Bool]()
    var businessListTemp = [[String]]()
    
    @IBOutlet weak var tf_ListName: UITextField!
    @IBOutlet weak var tf_SearchText: UITextField!
    @IBOutlet weak var tf_Category: UITextField!
    @IBOutlet weak var tf_Location: UITextField!
    
    @IBOutlet weak var bgExit: UIButton!

    
    @IBAction func doneWithKeyboard(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
        print("done with keyboard")
        tf_ListName.resignFirstResponder()
        tf_SearchText.resignFirstResponder()
        tf_Location.resignFirstResponder()
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        
        // Check if user has entered search text
        if tf_SearchText.text != "" {
            myLists.append(tf_ListName.text!)
            
            Business.searchWithTerm(term: tf_SearchText.text!, limit: 40, location: tf_Location.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                if (businesses != nil && (businesses?.count)! > 0) {
                    self.businesses = businesses
                    selectedList = myLists.count-1
                    selectedDataArray.removeAll()
                    
                    for business in businesses! {
                        selectedDataArray.append([business.name!, String(describing: business.url), self.tf_Location.text!, String(describing: business.ratingImageURL)])
                        self.businessListTemp.append([business.name!, String(describing: business.url), self.tf_Location.text!, String(describing: business.ratingImageURL)])
                        self.checkedBusinesssTemp.append(false)
                    }
                    
                    checkedBusinesses.append(self.checkedBusinesssTemp)
                    BusinessList.append(self.businessListTemp)
                    
                    if let plist = Plist(name: "data") {
                        plist.saveFile()
                    } else {
                        print("Unable to get Plist")
                    }
                    
                    self.performSegue(withIdentifier: "goToList", sender: self)
                    
                } else {
                    print("No businesses returned")
                    let alertController = UIAlertController(title: "Opps", message: "Sorry, we can't seem to find a business with that description.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            )
        } else {
            let alertController = UIAlertController(title: "Opps", message: "Please enter search text.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New List"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.hideKeyboardWhenTappedAround()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.title = "Back"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
