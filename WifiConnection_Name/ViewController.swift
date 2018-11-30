//
//  ViewController.swift
//  WifiConnection_Name
//
//  Created by SMSCountry Networks Pvt. Ltd on 31/10/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreData
import UserNotifications
import PassKit

extension Date {
    
    func getDateOnly() -> Date {
        
        let dateFormObj = DateFormatter()
        dateFormObj.dateFormat = "dd/MM/yyyy"
        dateFormObj.locale = Locale.init(identifier: "en_US_POSIX")
//        dateFormObj.timeZone = TimeZone.init(abbreviation: "UTC")
        let dateString =  dateFormObj.string(from: self)
        if let newDate = dateFormObj.date(from: dateString) {
            return newDate
        }
        else{
            return self
        }
    }
    
    func getStringFromDate() -> String {
        let dateFormObj = DateFormatter()
        dateFormObj.dateFormat = "dd/MM/yyyy"
        dateFormObj.locale = Locale.init(identifier: "en_US_POSIX")

//        dateFormObj.timeZone = TimeZone.init(abbreviation: "UTC")
        let dateString =  dateFormObj.string(from: self)
        return dateString
    }
    
    func getTimeFromDate() -> String {
        let dateFormObj = DateFormatter()
        dateFormObj.dateFormat = "hh:mm:ss a"
        dateFormObj.locale = Locale.init(identifier: "en_US_POSIX")

//        dateFormObj.timeZone = TimeZone.init(abbreviation: "UTC")
        let dateString =  dateFormObj.string(from: self)
        return dateString
    }
    
    func getDateAndTime() -> Date {
        
        let dateFormObj = DateFormatter()
        dateFormObj.dateFormat = "dd-MM-yyyy hh:mm:ss a"
        dateFormObj.locale = Locale.init(identifier: "en_US_POSIX")

//        dateFormObj.timeZone = TimeZone.init(abbreviation: "UTC")
        let dateString = dateFormObj.string(from: self)
        if let newDate = dateFormObj.date(from: dateString) {
            return newDate
        }
        else{
            return self
        }
    }
    
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    
}

extension Array where Element: Equatable {
    
    @discardableResult mutating func remove(object: Element) -> Bool {
        if let index = index(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.index(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
}


class ViewController: UIViewController,PKAddPassesViewControllerDelegate {
    
    @IBOutlet weak var networkStatus: UILabel!
    @IBOutlet weak var tbofRecords : UITableView!
    
    var arrofWifiObjeces : NSMutableArray = []
    
    var reachability: Reachability?
    let hostNames = ["google.com"]
    var hostIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        getWifiConnectionName()
        
//        let ssid = getAllWiFiNameList()
//        print("SSID: \(String(describing: ssid!))")
//        insertRecoprtd()
//        retrieveData()
        
        
        /*
         startHost(at: 0)
       retrieveData()
        */
        
        
        
        
        
        
        
        
      //  openPKPassfile()
    }
    
    func openPKPassfile(){

        let filePath = Bundle.main.path(forResource: "41502113", ofType:"pkpass")
        let pkfile : NSData = NSData(contentsOfFile: filePath!)!
        do {
            let pass : PKPass = try PKPass(data: pkfile as Data)
            let vc = PKAddPassesViewController(pass: pass) as! PKAddPassesViewController
            self.present(vc, animated: true, completion: nil)
        }
        catch let error as Error {

        }
    
        
        
//        if let filepath = Bundle.main.url(forResource: "freehugcoupon", withExtension: "pkpass") {
//            do {
//                let pkfile : Data = try! Data(contentsOf: filepath)
//                do {
//                    let pass : PKPass = try! PKPass(data: pkfile)
//                    let vc = PKAddPassesViewController(pass: pass)
//                    self.present(vc!, animated: true, completion: nil)
//                }
//                catch let errir as Error {
//                    print("Error is \(errir.localizedDescription)")
//                }
//
//            }
//            catch let error as Error {
//                print("error is \(error.localizedDescription)")
//            }
//
//        } else {
//            print("Boarding pass not found.")
//        }

    }
    
    
//    func getWiFiAddress() -> String? {
//        var address : String?
//
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//
//            // For each interface ...
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr.memory.ifa_next }
//
//                let interface = ptr.memory
//
//                // Check for IPv4 or IPv6 interface:
//                let addrFamily = interface.ifa_addr.memory.sa_family
//                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                    // Check interface name:
//                    if let name = String.fromCString(interface.ifa_name), name == "en0" {
//
//                        // Convert interface address to a human readable string:
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.memory.sa_len),
//                                    &hostname, socklen_t(hostname.count),
//                                    nil, socklen_t(0), NI_NUMERICHOST)
//                        address = String.fromCString(hostname)
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//
//        return address
//    }
//
    
    
    
   
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.startHost(at: (index + 1) % 3)
//        }
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
         //   hostNameLabel.text = hostName
        } else {
            reachability = Reachability()
         //   hostNameLabel.text = "No host name"
        }
        self.reachability = reachability
//        print("--- set up with host name: \(hostNameLabel.text!)")
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateLabelColourWhenNotReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            networkStatus.textColor = .red
            networkStatus.text = "Unable to start\nnotifier"
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    func insertRecoprtd(){
        
//        let tomorrow : Date! = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let tomorrow : Date! = Date()

        let wfObj = WIFIObject.init(givenName: "Aruba", givenDate: tomorrow.getDateOnly(), givenIPTime: tomorrow.getDateAndTime(), givenOPTime: tomorrow.getDateAndTime())
        
//        let cdOperations = CDWifiConnectins.init()
        CoreDataManager.sharedManager.insertWifiObj(wfConObj:wfObj)
    }

    
    func insertRecoprt2d(){
        
        let tomorrow : Date! = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        //     let tomorrow : Date! = Date()
        
        let wfObj = WIFIObject.init(givenName: "Aruba", givenDate: tomorrow.getDateOnly(), givenIPTime: tomorrow.getDateAndTime(), givenOPTime: tomorrow.getDateAndTime())
        
        let cdOperations = CDWifiConnectins.init()
        cdOperations.insertNewRecord(wfConObj: wfObj)
    }
    
    
    func fireLocalNotification(){
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notify-test"
        
        //need to insert new record to db
       // insertRecoprt2d()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    
    
    func updateLastRecord(){
//        let cdOperations = CDWifiConnectins.init()
        CoreDataManager.sharedManager.updateLastRecord(outPunchDate: Date().getDateAndTime())
    }
    
    func retrieveData(){
        
//        let cdOperation = CDWifiConnectins.init()
        CoreDataManager.sharedManager.fetchedResultsController.delegate = self
        do{
            
            print("2. NSFetchResultController will start fetching :)")
            /*initiate performFetch() call on fetchedResultsController*/
            try CoreDataManager.sharedManager.fetchedResultsController.performFetch()
            print("3. NSFetchResultController did end fetching :)")
            
        }catch{
            print(error)
        }
        let arrofRes = CoreDataManager.sharedManager.retrievData()
        splitRecordsasPerDate(arrofRes)
        print(arrofWifiObjeces)
        
        tbofRecords.reloadData()
        
//        for wifiObj in arrofRes {
//            print(wifiObj.inpunchTime)
//            print(wifiObj.requestedDate)
//        }
    }
    
    //create a dictonary like Date : "1-11-2018" , Timings : [{IP : "",OP:""}]
    
    
    func checkIfSameDayRecordExist(_ seleDate : Date) ->(Bool, NSMutableDictionary?){
      
        var seleObj : NSMutableDictionary?
        var isObjExist : Bool = false
        
        
        for case let dicctofObj as NSMutableDictionary in arrofWifiObjeces {
             let strofDate   = String(describing: dicctofObj["Date"]!)
             let strofReque = seleDate.getStringFromDate()
                if strofDate == strofReque {
                      isObjExist = true
                      seleObj = dicctofObj
                      break
                }
            
        }
        
//        for wifiObj in arrfoObjects {
//            if wifiObj.requestedDate == seleDate {
//                isObjExist = true
//                seleObj = wifiObj
//                break
//            }
//        }
        
        return (isObjExist,seleObj)
    }
    
    func splitRecordsasPerDate(_ arrofWifiObjs : [WifiConnections]) {
        
        var arrofResponseCopy = arrofWifiObjs
        
        for wifiObj in arrofResponseCopy {
           let requestDate = wifiObj.requestedDate!
            //need to check any record exist with this
            
            arrofResponseCopy.remove(object: wifiObj)
            
            let (isExist,seleWifiObj) = checkIfSameDayRecordExist(requestDate)
            if isExist == true {
                let arrofPunches : NSMutableArray = seleWifiObj?.value(forKey: "Timings") as? NSMutableArray ?? []
                arrofPunches.add(wifiObj)
                
            }
            else{
                let newDictObj = NSMutableDictionary.init()
                newDictObj.setValue(requestDate.getStringFromDate(), forKeyPath: "Date")
                
                let arrofPunches = NSMutableArray.init()
                arrofPunches.add(wifiObj)
                newDictObj.setValue(arrofPunches, forKeyPath: "Timings")
                
                arrofWifiObjeces.add(newDictObj)
//                arrofResponseCopy.remove(at: index-1)
            }
        }
        
    }
    
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        if reachability.connection == .wifi {
            //check the wifi name :
            
            //ARUBA or  case sensitive
            if String(describing: getWifiConnectionName()) == "Aruba" {
                //insert record in db
                insertRecoprtd()
               // retrieveData()
            }else{
                
            }
            
            self.networkStatus.textColor = .green
        } else {
            
            //if not wifi or not reachable
            //get last record and update out punch
            
            updateLastRecord()
           // retrieveData()
            self.networkStatus.textColor = .blue
        }
        
        self.networkStatus.text = "\(String(describing: getWifiConnectionName()))"
    }
    
   
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        
          if reachability.connection == .wifi {
        //get last record check out-time is euqal to in-time, update out punch as out-time
//             if String(describing: self.getAllWiFiNameList()!) == "Aruba" {
//
//             }else{
//
//            }
        }
        self.networkStatus.textColor = .red
         updateLastRecord()
    //    retrieveData()
        self.networkStatus.text = "\(String(describing: getWifiConnectionName()))"
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
    
    deinit {
        stopNotifier()
    }
    
    
    func getAllWiFiNameList() -> String {
        var ssid: String = "No Conn"
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = (interfaceInfo[kCNNetworkInfoKeySSID as String] as? String)!
                    break
                }
            }
        }
        return ssid
    }
    
    func getWifiConnectionName() -> String {
        
        var strConnectionName : String = "NO NAME"
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            
//            print("array of content")
//            print(interfaces)
            
            for interface in interfaces {
            if let interfaceInfo =  CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {

                    strConnectionName = interfaceInfo[kCNNetworkInfoKeySSID as String] as! String

//                if let bssidName = interfaceInfo[kCNNetworkInfoKeyBSSID as CFString] as? String {
//                    print("wifi bssid name is : \(bssidName)")
//                }
//                //kCNNetworkInfoKeySSIDData
//                if let bssidData = interfaceInfo[kCNNetworkInfoKeySSIDData as CFString] as? String {
//                    print("wifi bssidData name is : \(bssidData)")
//                }
                    print("wifi name is : \(strConnectionName)")
                    break
                }
            }
        }
        return strConnectionName
    }
}


extension ViewController : UITableViewDataSource,UITableViewDelegate {


    func numberOfSections(in tableView: UITableView) -> Int {
        return arrofWifiObjeces.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictofObj = arrofWifiObjeces[section] as! NSMutableDictionary
        let arrofTimins = dictofObj.object(forKey: "Timings") as! NSMutableArray
        return arrofTimins.count
    }
    /* let cell = tableView.dequeueReusableCell(withIdentifier: "PatientPaymentCardsCell") as! PatientPaymentCardsCell
     let paymentGateway = self.paymentGateways[indexPath.row] as! NSDictionary
     if L102Language.currentAppleLanguage() == "en" {
     cell.lblOfGatewayName.text = String(describing: paymentGateway.TabiibDocObjectForKey(forKey: PatMenuUpdates.APIResponse.pg_Name))
     }else{
     cell.lblOfGatewayName.text = String(describing: paymentGateway.TabiibDocObjectForKey(forKey: PatMenuUpdates.APIResponse.pg_Name))
     }
     
     cell.selectionStyle = .none
     return cell
     */
    
    func getDuration(_ wifiConObj : WifiConnections) -> String {
        
        let interel = wifiConObj.outpunchTime?.interval(ofComponent: .minute, fromDate: wifiConObj.inpunchTime!)
        let tupleVal = minutesToHoursMinutes(minutes: interel!)
        let hours = tupleVal.hours
        let minutes = tupleVal.leftMinutes
        
        return "\(hours) : \(minutes)"
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let wifiConobjCell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursTableViewCell") as! WorkingHoursTableViewCell
        let dictofObj = arrofWifiObjeces[indexPath.section] as! NSMutableDictionary
        let arrofTimins = dictofObj.object(forKey: "Timings") as! [WifiConnections]
        let wifiConObj = arrofTimins[indexPath.row]
        wifiConobjCell.lblofInpunch.text = wifiConObj.inpunchTime?.getTimeFromDate()
        wifiConobjCell.lblofOutPunch.text = wifiConObj.outpunchTime?.getTimeFromDate()
        wifiConobjCell.lblofDuration.text = getDuration(wifiConObj)
        return wifiConobjCell
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell") as! DateTableViewCell
//        headerCell.btnOfVouchers.addTarget(self, action: #selector(btnOfVouchersAction(_:)), for: .touchUpInside)
//        headerCell.lblOfTotalAmount.text = getTotalAmount()
        
        let dicotfObj = arrofWifiObjeces[section] as! NSMutableDictionary
        
        headerCell.lblReqDate.text = String(describing: dicotfObj.object(forKey: "Date")!)
      
        return headerCell
        
        
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    
    func configureCell(_ cell : DateTableViewCell, indexPathObj : IndexPath){
        
        let cdOperations = CDWifiConnectins.init()
        let wifiObj = cdOperations.fetchedResultController.object(at: indexPathObj)
        
        
        print(wifiObj)
    }

}


extension ViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("content is modified")
        tbofRecords.beginUpdates()
    }
    
    
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("objet changes ....\(type.rawValue)")
        
        
        switch type {
        case .insert:
            retrieveData()
            break
        case .delete :
            break
        case .update :
            
//            if let indexPAth = indexPath, let cellobj = tbofRecords.cellForRow(at: indexPath!) {
//
//                configureCell(cellobj as! DateTableViewCell, indexPathObj: indexPAth)
//            }
            retrieveData()
//            tbofRecords.reloadData()
            
            break
        case .move:
            break
        default:
            break
        }
        
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("udapted done")
        tbofRecords.endUpdates()
    }
    
    
}
