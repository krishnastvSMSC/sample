//
//  WifiConnections+CoreDataProperties.swift
//  WifiConnection_Name
//
//  Created by SMSCountry Networks Pvt. Ltd on 31/10/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension WifiConnections {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WifiConnections> {
        return NSFetchRequest<WifiConnections>(entityName: "WifiConnections")
    }

    @NSManaged public var wifiName: String?
    @NSManaged public var inpunchTime: Date?
    @NSManaged public var outpunchTime: Date?
    @NSManaged public var requestedDate: Date?

    
    
}
