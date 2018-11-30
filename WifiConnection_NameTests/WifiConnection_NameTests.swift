//
//  WifiConnection_NameTests.swift
//  WifiConnection_NameTests
//
//  Created by SMSCountry Networks Pvt. Ltd on 31/10/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import XCTest
@testable import WifiConnection_Name

class WifiConnection_NameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
    
    func testValidNetwork(){
        
        
        let strValidHost = "invaliasd"
        
        guard  let reachability =  Reachability(hostname: strValidHost) else {
            return XCTFail("Uanable to create reachability")
        }
        
        
        let expected = expectation(description: "Check valid post")
        reachability.whenReachable = { reachability in
            print("Pass : \(strValidHost) is initially reachable")
            expected.fulfill()
        }
        
        reachability.whenUnreachable = { reachability in
            print("\(strValidHost) is initially unreachable - \(reachability)")
            // Expectation isn't fulfilled here, so wait will time out if this is the only closure called
        }
        
        
        do {
            try reachability.startNotifier()
        } catch  {
            return XCTFail("Unable to start notifier")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        reachability.stopNotifier()
    }

    
    
    func testInsertRecord(){
        let wfObj = WIFIObject.init(givenName: "Aruba", givenDate: Date(), givenIPTime: Date(), givenOPTime: Date())
        
        let cdOperations = CDWifiConnectins.init()
        cdOperations.insertNewRecord(wfConObj: wfObj)
    }
    
    
}
