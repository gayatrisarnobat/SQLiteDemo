//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by Gayatri Sarnobat on 10/06/17.
//  Copyright © 2017 Gayatri Sarnobat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet var tblPeople: UITableView!
    
    // MARK: Private Properties
    private var people : [Person]? = [Person] ()
    private var detailsVC : DetailsViewController?
    
    // MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tblPeople.contentInset = UIEdgeInsets.zero
        self.reloadTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Other Helpers
    func reloadTableData(){
        // 1 : Fetch Records
        people = Person.fetchRecords()
        // 2 : Reload table
        self.tblPeople.reloadData()
    }
    
    // MARK: Button Clicks
    @IBAction func btnAddClicked(_ sender: Any) {
        if self.detailsVC != nil{
            self.navigationController?.popToViewController(self, animated: true)
            self.detailsVC = nil
        }
        self.detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as? DetailsViewController
        
        self.detailsVC?.setUpProperties(isAdding: true, personObj: nil)
        self.navigationController?.pushViewController(self.detailsVC!, animated: true)
    }
    
    // MARK: Table View Delegate and Datasource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (people?.count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tblPeople.dequeueReusableCell(withIdentifier: "cellId") as! PersonTableCell
        let person = (people?[indexPath.row])!
        cell.lblPersonName.text = "Name     : \(person.name!) \nAge         : \(person.age!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let person = (people?[indexPath.row])!
            person.deleteRecord()
            self.reloadTableData()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tblPeople.deselectRow(at: indexPath, animated: true)
        let person = (people?[indexPath.row])!
        if self.detailsVC != nil{
            self.navigationController?.popToViewController(self, animated: true)
            self.detailsVC = nil
        }
        self.detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as? DetailsViewController
        
        self.detailsVC?.setUpProperties(isAdding: false, personObj: person)
        self.navigationController?.pushViewController(self.detailsVC!, animated: true)
    }
}

