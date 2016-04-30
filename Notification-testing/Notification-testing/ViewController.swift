//
//  ViewController.swift
//  Notification-testing
//
//  Created by Yingbo Wang on 4/29/16.
//  Copyright © 2016 Yingbo Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // a testing Notification: based on Objective-C, not useful
        /*
        UILocalNotification* localNotification = [[UILocalNotificationalloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
        localNotification.alertBody = @"Your alert message";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        */
        
        // Ask for notification permission
        registerLocal(UIViewController)
    }

    @IBAction func schedulePushed(sender: UIButton) {
        // schedule a testing local notification
        scheduleLocal(UIViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerLocal(sender: AnyObject) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleLocal(sender: AnyObject) {
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        // if notification failed to initialize
        if settings.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) // wait for 5 seconds before notifying
        notification.alertBody = "Notification testing at LA Hacks 2016."
        notification.alertAction = "Attend LA Hacks" // Displayed as "Slide to..."
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "Sara-Max"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
}

