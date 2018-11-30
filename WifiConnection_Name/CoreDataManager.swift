//
//  CoreDataManager.swift
//  WifiConnection_Name
//
//  Created by SMSCountry Networks Pvt. Ltd on 05/11/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WifiConnection_Name")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func insertWifiObj(wfConObj : WIFIObject) {
        let managedObj = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let wifConObj = WifiConnections(context: managedObj)
        wifConObj.wifiName = wfConObj.strofName
        wifConObj.requestedDate = wfConObj.dateofEntry
        wifConObj.inpunchTime = wfConObj.timeofInpunch
        wifConObj.outpunchTime = wfConObj.timeofOutpunch
        
        do {
            try managedObj.save()
        } catch let error as NSError {
            print("Cound not save.\(error),\(error.userInfo)")
        }
    }
    
    
    func updateLastRecord(outPunchDate : Date) {
        
        let arrofExistingData = self.retrievData()
        
        let managedObj = CoreDataManager.sharedManager.persistentContainer.viewContext

        if arrofExistingData.count > 0 {
            //records exist
            //get let record
            let lastWFObject = arrofExistingData.last
            lastWFObject!.outpunchTime = outPunchDate
            
            do {
                try managedObj.save()
            }
            catch let error as NSError {
                print("Error at last entry update. \(error), .\(error.localizedDescription)")
            }
            
        }
    }
    
    func retrievData() -> [WifiConnections]{
        let managedObj = CoreDataManager.sharedManager.persistentContainer.viewContext

        var arrofResponse : [WifiConnections] = []
        do {
            let resultObjs =  try managedObj.fetch(WifiConnections.createFetchRequest())
            for data in resultObjs as! [WifiConnections] {
                print("object is")
                print(data)
                arrofResponse = resultObjs
            }
        } catch let errror as NSError {
            print("Error at retrieve. \(errror), \(errror.localizedDescription)")
        }
        return arrofResponse
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<WifiConnections> = {
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let fetchRequest = NSFetchRequest<WifiConnections>(entityName: "WifiConnections")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "inpunchTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController<WifiConnections>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        print("1. NSFetchResultController Initialized :)")
        return fetchedResultsController
    }()
}
