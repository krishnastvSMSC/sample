//
//  AppDelegate.swift
//  WifiConnection_Name
//
//  Created by SMSCountry Networks Pvt. Ltd on 31/10/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import PassKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var timerObj : Timer?
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return true
    }
    
    private func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool
    {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let path = components.path,
            let params = components.queryItems else {
                return false
        }
//        print("params :\(params)")
        print("path = \(path)")
        
//        if let albumName = params.first(where: { $0.name == "albumname" } )?.value,
//            let photoIndex = params.first(where: { $0.name == "index" })?.value {
//
//            print("album = \(albumName)")
//            print("photoIndex = \(photoIndex)")
//            return true
//
//        } else {
//            print("Either album name or photo index missing")
//            return false
//        }
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed!")
            } else {
                print("Request authorization succeeded!")
            }
            
        }
        
        
        
        let strOfVal = "12.00"
        print(Double(strOfVal) as Any)
        
        
        application.setMinimumBackgroundFetchInterval(60 * 1)

        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //   SLNScheduler.start(completion: completionHandler)
        print("background fetch started")
        fireLocalNotification()
        // application.setMinimumBackgroundFetchInterval(30)
        
        completionHandler(.newData)
        
    }
    
    func insertRecoprtd(){
        
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
     //   insertRecoprtd()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
        timertoCallNotification()
    }
    
    
    func timertoCallNotification(){
        timerObj = Timer(timeInterval: 5, target: self, selector:#selector(triggerNotification), userInfo: nil, repeats: true)
    }
    
    @objc func triggerNotification(){
        fireLocalNotification()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

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

}

