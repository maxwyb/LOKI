//
//  RemotePeripheralViewController.swift
//  LokiTest
//
//  Created by Sara Du on 4/30/16.
//  Copyright © 2016 Sara Du. All rights reserved.
//

import UIKit
import BluetoothKit
import CoreLocation

internal protocol RemotePeripheralViewControllerDelegate: class {
    func remotePeripheralViewControllerWillDismiss(remotePeripheralViewController: RemotePeripheralViewController)
}

internal class RemotePeripheralViewController: UIViewController, BKRemotePeripheralDelegate {
    
    // MARK: Properties
    
    internal weak var delegate: RemotePeripheralViewControllerDelegate?
    internal let remotePeripheral: BKRemotePeripheral
    
    private let logTextView = UITextView()
    
    // MARK: Initialization
    
    internal init(remotePeripheral: BKRemotePeripheral) {
        self.remotePeripheral = remotePeripheral
        super.init(nibName: nil, bundle: nil)
        self.remotePeripheral.delegate = self
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK: UIViewController Life Cycle
    
    internal override func viewDidLoad() {
        navigationItem.title = remotePeripheral.name
        view.addSubview(logTextView)
        view.backgroundColor = UIColor.whiteColor()
        logTextView.editable = false
        logTextView.alwaysBounceVertical = true
        //applyConstraints()
        print("Awaiting data from peripheral")
    }
    
    internal override func viewWillDisappear(animated: Bool) {
        delegate?.remotePeripheralViewControllerWillDismiss(self)
    }
    
    // MARK: Functions
    
    /*
    internal func applyConstraints() {
        logTextView.snp_makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
    }
    */
    // MARK: BKRemotePeripheralDelegate
    
    internal func remotePeripheral(remotePeripheral: BKRemotePeripheral, didUpdateName name: String) {
        navigationItem.title = name
        print("Name change: \(name)")
    }
    
    //Data is received from the peripheral's "Send Data"
    internal func remotePeripheral(remotePeripheral: BKRemotePeripheral, didSendArbitraryData data: NSData) {
        //Logger.log("Received data of length: \(data.length) with hash: \(data.md5()!.hexString)")
        let data1 = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! CLLocation
        print(data1)
        print("Received data of length: \(data.length) with value: \(data1)")
        
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
