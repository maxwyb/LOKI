//
//  PeripheralViewController.swift
//  LokiTest
//
//  Created by Sara Du on 4/30/16.
//  Copyright © 2016 Sara Du. All rights reserved.
//

import UIKit
import BluetoothKit
import CoreLocation

internal class PeripheralViewController: UIViewController, AvailabilityViewController, BKPeripheralDelegate, LoggerDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    internal var availabilityView = AvailabilityView()
    
    private let peripheral = BKPeripheral()
    private let logTextView = UITextView()
    private lazy var sendDataBarButtonItem: UIBarButtonItem! = { UIBarButtonItem(title: "Send Data", style: UIBarButtonItemStyle.Plain, target: self, action: "sendData") }()
    
    // MARK: UIViewController Life Cycle
    private var currlocation: CLLocation!
    private var locationManager: CLLocationManager!
    internal override func viewDidLoad() {
        if(self.locationManager == nil){
            print("initailizaing")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        navigationItem.title = "Peripheral"
        view.backgroundColor = UIColor.whiteColor()
        Logger.delegate = self
        applyAvailabilityView()
        logTextView.editable = false
        logTextView.alwaysBounceVertical = true
        view.addSubview(logTextView)
        applyConstraints()
        startPeripheral()
        sendDataBarButtonItem.enabled = false
        navigationItem.rightBarButtonItem = sendDataBarButtonItem
    }
    
    deinit {
        try! peripheral.stop()
    }
    
    
    // MARK: Location
    func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]){
            currlocation = manager.location!
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                print("Restricted Access to location")
            case CLAuthorizationStatus.Denied:
                print("User denied access to location")
            case CLAuthorizationStatus.NotDetermined:
                print("Status not determined")
            default:
                print("Allowed to location Access")
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access")
            }
    }
    
    
    // MARK: Functions
    private func applyConstraints() {
        logTextView.snp_makeConstraints { make in
            make.top.equalTo(snp_topLayoutGuideBottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(availabilityView.snp_top)
        }
    }
    
    //This is where the friend starts to look for friend requests
    private func startPeripheral() {
        do {
            peripheral.delegate = self
            peripheral.addAvailabilityObserver(self)
            let dataServiceUUID = NSUUID(UUIDString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!
            let dataServiceCharacteristicUUID = NSUUID(UUIDString: "477A2967-1FAB-4DC5-920A-DEE5DE685A3D")!
            let localName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String
            let configuration = BKPeripheralConfiguration(dataServiceUUID: dataServiceUUID, dataServiceCharacteristicUUID: dataServiceCharacteristicUUID, localName: localName)
            try peripheral.startWithConfiguration(configuration)
            Logger.log("Awaiting connections from remote centrals")
        } catch let error {
            print("Error starting: \(error)")
        }
    }
    
    // MARK: Target Actions
    
    //Send Data is pressed and data is sent
    @objc private func sendData() {
        //let numberOfBytesToSend: Int = Int(arc4random_uniform(950) + 50)
        //let data = NSData.dataWithNumberOfBytes(numberOfBytesToSend)
        //Logger.log("Prepared \(numberOfBytesToSend) bytes with MD5 hash: \(data.md5()!.hexString)")
        let data = NSKeyedArchiver.archivedDataWithRootObject(currlocation)
        for remoteCentral in peripheral.connectedRemoteCentrals {
            Logger.log("Sending to \(remoteCentral)")
            peripheral.sendData(data, toRemoteCentral: remoteCentral) { data, remoteCentral, error in
                guard error == nil else {
                    Logger.log("Failed sending to \(remoteCentral)")
                    return
                }
                Logger.log("Sent to \(remoteCentral)")
                
            }
        }
    }
    
    // MARK: BKPeripheralDelegate
    
    //Sent by peripheral when the friend request is successfully sent; user is added to contacts
    internal func peripheral(peripheral: BKPeripheral, remoteCentralDidConnect remoteCentral: BKRemoteCentral) {
        Logger.log("Remote central did connect: \(remoteCentral)")
        sendDataBarButtonItem.enabled = true
    }
    
    internal func peripheral(peripheral: BKPeripheral, remoteCentralDidDisconnect remoteCentral: BKRemoteCentral) {
        Logger.log("Remote central did disconnect: \(remoteCentral)")
        sendDataBarButtonItem.enabled = false
    }
    
    // MARK: LoggerDelegate
    
    internal func loggerDidLogString(string: String) {
        if logTextView.text.characters.count > 0 {
            logTextView.text = logTextView.text.stringByAppendingString("\n" + string)
        } else {
            logTextView.text = string
        }
        logTextView.scrollRangeToVisible(NSMakeRange(logTextView.text.characters.count - 1, 1))
    }
    
}
