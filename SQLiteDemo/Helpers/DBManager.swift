//
//  DBManager.swift
//  SQLiteDemo
//
//  Created by Gayatri Sarnobat on 10/06/17.
//  Copyright © 2017 Gayatri Sarnobat. All rights reserved.
//

import Foundation

class DBManager{
    
    // MARK: Class Interface
    static let sharedInstance = DBManager()
    
    // MARK: Private Properties and Methods
    private var documentsDirectoryURL : URL!
    private var dbPathURL : URL!
    
    private init() {
        self.documentsDirectoryURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        self.dbPathURL = self.documentsDirectoryURL.appendingPathComponent(Constants.dbName)
    }
    
    // MARK: DB Helpers
    func openDatabase() -> OpaquePointer?{
        var db : OpaquePointer? = nil
        if sqlite3_open(self.dbPathURL.absoluteString, &db) == SQLITE_OK{
            print("Successfully Opened Connection to db at \(self.dbPathURL.absoluteString)")
            return db
        }
        return nil;
    }
    
    func closeDatabase(db : OpaquePointer!){
        sqlite3_close(db)
        print("Closed database connection")
    }
    
    func createTable(db : OpaquePointer!, createTableStr : String!){
        var createTableStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableStr!, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Table Created Successfully")
            }else{
                print("Table could not be created")
            }
        }else{
            print("CREATE TABLE statement could not be prepared")
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    func deleteTableRow(deleteStatementStr : String!){
        let db = DBManager.sharedInstance.openDatabase()
        
        var deleteStatement  : OpaquePointer? = nil
        
        if sqlite3_prepare(db, deleteStatementStr, -1, &deleteStatement, nil) == SQLITE_OK{
            if sqlite3_step(deleteStatement) == SQLITE_DONE{
                print("Deleted record successfully")
            }else{
                print("Could not delete record")
            }
        }else{
            print("Could not prepare delete statement : \(deleteStatementStr)")
        }
        
        DBManager.sharedInstance.closeDatabase(db: db)
    }
}
