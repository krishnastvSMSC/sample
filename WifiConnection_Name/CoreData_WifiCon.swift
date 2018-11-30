
//
//  CoreData_WifiCon.swift
//  WifiConnection_Name
//
//  Created by SMSCountry Networks Pvt. Ltd on 31/10/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct WIFIObject {
    
    var strofName : String?
    var dateofEntry : Date?
    var timeofInpunch : Date?
    var timeofOutpunch : Date?

    init(givenName : String, givenDate : Date, givenIPTime : Date, givenOPTime : Date) {
        
        self.strofName = givenName
        self.dateofEntry = givenDate
        self.timeofInpunch = givenIPTime
        self.timeofOutpunch = givenOPTime
        
    }
    
}



class CDWifiConnectins: NSObject {
    
    let  appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mangedObjectContext : NSManagedObjectContext?
    
    //MARK: - - - initialization
    
    override init() {
        
//        appDelegate = UIApplication.shared.delegate as! AppDelegat
        mangedObjectContext = appDelegate.persistentContainer.viewContext
        
    }
    
    //MARK: - - - insert new record
    func insertNewRecord(wfConObj : WIFIObject){
        
        let wfEntity = NSEntityDescription.entity(forEntityName: "WifiConnections", in: mangedObjectContext!)
        
        let wifConObj = WifiConnections.init(entity: wfEntity!, insertInto: mangedObjectContext)
        wifConObj.wifiName = wfConObj.strofName
        wifConObj.requestedDate = wfConObj.dateofEntry
        wifConObj.inpunchTime = wfConObj.timeofInpunch
        wifConObj.outpunchTime = wfConObj.timeofOutpunch
        
        do {
            try mangedObjectContext?.save()
        } catch let error as NSError {
            print("Cound not save.\(error),\(error.userInfo)")
        }
    }
    
    
    //MARK: - - - retrieve all records
    func retrievData() -> [WifiConnections]{
        var arrofResponse : [WifiConnections] = []
        do {
           let resultObjs =  try mangedObjectContext?.fetch(WifiConnections.createFetchRequest())
            for data in resultObjs as! [WifiConnections] {
                print("object is")
                print(data)
                arrofResponse = resultObjs!
            }
        } catch let errror as NSError {
            print("Error at retrieve. \(errror), \(errror.localizedDescription)")
        }
        return arrofResponse
    }
    
    
    //MARK: - - -  update last record
    func updateLastEntryOutTime(outPunchDate : Date){
        
        let arrofExistingData = self.retrievData()
        
        if arrofExistingData.count > 0 {
            //records exist
            //get let record
            let lastWFObject = arrofExistingData.last
            lastWFObject!.outpunchTime = outPunchDate
            
            do {
                try mangedObjectContext?.save()
            }
            catch let error as NSError {
                print("Error at last entry update. \(error), .\(error.localizedDescription)")
            }
            
        }
    }
    
    
    
    
    lazy var fetchedResultController : NSFetchedResultsController<WifiConnections> = {
        
        let fetchRequest = NSFetchRequest<WifiConnections>(entityName: "WifiConnections")
        let fetchResuCon = NSFetchedResultsController<WifiConnections>(fetchRequest: fetchRequest, managedObjectContext: mangedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResuCon
    }()
}
