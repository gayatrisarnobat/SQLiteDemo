//
//  DetailsViewController.swift
//  SQLiteDemo
//
//  Created by Gayatri Sarnobat on 11/06/17.
//  Copyright © 2017 Gayatri Sarnobat. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet var txtFldPersonId: UITextField!
    @IBOutlet var txtFldPersonName: UITextField!
    @IBOutlet var txtFldPersonAge: UITextField!
    @IBOutlet var btnSave: UIButton!
    
    // MARK: Button Clicks
    @IBAction func btnSaveClicked(_ sender: Any) {
        if(self.txtFldPersonName.text?.isEmpty)!{
            self.showAlert(title: "Name", message: "Enter name")
        }else if(self.txtFldPersonAge.text?.isEmpty)!{
            self.showAlert(title: "Age", message: "Enter age")
        }
        
        if self.isAdding{
            self.personObj = Person(name: (self.txtFldPersonName.text)!, age: Int((self.txtFldPersonAge.text)!))
            self.personObj?.insertPersonIntoDatabase()
        }else{
            self.personObj?.name = (self.txtFldPersonName.text)!
            self.personObj?.age = Int((self.txtFldPersonAge.text)!)
            self.personObj?.updatePerson()
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Private Properties
    private var isAdding : Bool = false
    private var personObj : Person?
    
    // MARK: Set Up Methods
    func setUpProperties(isAdding : Bool, personObj : Person?){
        self.isAdding = isAdding
        self.personObj = personObj
    }
    
    // MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // also show back button
        self.navigationController?.navigationItem.hidesBackButton = false
        self.title = self.isAdding ? "Add Person" : "Details"
        
        // set up text fields
        if(!self.isAdding){
            if let person = self.personObj{
                self.txtFldPersonId.text = "\(person.personId!)"
                self.txtFldPersonName.text = person.name
                self.txtFldPersonAge.text = "\(person.age!)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Other Helpers
    func showAlert(title : String!, message : String!){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: {(action : UIAlertAction!)  in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Text Field Delegate Methods
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return textField != self.txtFldPersonId
    }

}
