//
//  Person.swift
//  SQLiteDemo
//
//  Created by Gayatri Sarnobat on 11/06/17.
//  Copyright © 2017 Gayatri Sarnobat. All rights reserved.
//

import Foundation

class Person{
    // MARK: Properties
    var personId : Int? = nil
    var name : String! = ""
    var age : Int! = 0
    
    init(){
        
    }
    
    init(name : String!, age : Int!){
        self.name = name
        self.age = age
    }
    
    func description() -> String!{
        var str = ""
        if let personId = self.personId{
            str.append("Person Id: \(personId), ")
        }
        str.append("Name : \(self.name), Age : \(self.age)")
        return str
    }
    
    static func createTablePerson(){
        let db = DBManager.sharedInstance.openDatabase()
        let createTableStr : String! = "CREATE TABLE IF NOT EXISTS PERSON(personId INTEGER PRIMARY KEY NOT NULL, name CHAR(255), age INTEGER);"
        DBManager.sharedInstance.createTable(db: db, createTableStr: createTableStr!)
        DBManager.sharedInstance.closeDatabase(db: db)
    }
    
    static func fetchRecords() -> [Person]{
        var people = [Person] ()
        let db = DBManager.sharedInstance.openDatabase()
        Person.createTablePerson()
        let fetchStatementStr = "SELECT * FROM PERSON;"
        var fetchStatement : OpaquePointer?
        if sqlite3_prepare_v2(db, fetchStatementStr, -1, &fetchStatement, nil) == SQLITE_OK{
            while(sqlite3_step(fetchStatement) == SQLITE_ROW){
                let person = Person()
                person.personId = Int(sqlite3_column_int(fetchStatement, 0))
                person.name = String.init(cString: sqlite3_column_text(fetchStatement, 1))
                person.age = Int(sqlite3_column_int(fetchStatement, 2))
                people.append(person)
            }
        }
        DBManager.sharedInstance.closeDatabase(db: db)
        return people
    }
    
    func insertPersonIntoDatabase(){
        let db = DBManager.sharedInstance.openDatabase()
        let insertStatementStr = "INSERT INTO PERSON (name, age) VALUES (?, ?);"
        var insertStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementStr, -1, &insertStatement, nil) == SQLITE_OK{
            
            // bind statements
//            sqlite3_bind_int(insertStatement, 1, Int32(self.personId))
            sqlite3_bind_text(insertStatement, 1, self.name, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(self.age))
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Successfully inserted record : \(self.description())")
            }else{
                print("Could not insert record : \(self.description())")
            }
        }else{
            print("Insert statement could not be prepared : \(insertStatementStr)")
        }
        sqlite3_finalize(insertStatement)
        DBManager.sharedInstance.closeDatabase(db: db)
    }
    
    func updatePerson(){
        let db = DBManager.sharedInstance.openDatabase()
        let updateStatementStr = "UPDATE PERSON set name = '\(self.name!)', age = \(self.age!) where personId = \(self.personId!)"
        var updateStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStr, -1, &updateStatement, nil) == SQLITE_OK{
            if sqlite3_step(updateStatement) == SQLITE_DONE{
                print("Successfully updated record : \(self.description())")
            }else{
                print("Could not update record : \(self.description())")
            }
        }else{
            print("Update statement could not be prepared : \(updateStatementStr)")
        }
        sqlite3_finalize(updateStatement)
        DBManager.sharedInstance.closeDatabase(db: db)
    }
    
    func deleteRecord(){
        let deleteStatementStr = "DELETE FROM PERSON where personId == \(self.personId!)"
        DBManager.sharedInstance.deleteTableRow(deleteStatementStr: deleteStatementStr)
    }
    
}
