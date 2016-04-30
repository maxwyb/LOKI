//
//  RoleSelectionViewController.swift
//  LokiTest
//
//  Created by Sara Du on 4/30/16.
//  Copyright © 2016 Sara Du. All rights reserved.
//

import UIKit

internal class RoleSelectionViewController: UIViewController {
    
    // MARK: Properties
    
    private let offset = CGFloat(20)

     
    // MARK: UIViewController Life Cycle
    
    internal override func viewDidLoad() {
        navigationItem.title = "Select Role"
        //view.backgroundColor = UIColor.whiteColor()
        centralButton.setTitle("Central", forState: UIControlState.Normal)
        peripheralButton.setTitle("Peripheral", forState: UIControlState.Normal)
        preparedButtons([ centralButton, peripheralButton ], andAddThemToView: view)
        applyConstraints()
    }
    
    // MARK: Functions
    
    private func preparedButtons(buttons:[UIButton], andAddThemToView view: UIView) {
        for button in buttons {
            button.setBackgroundImage(UIImage.imageWithColor(buttonColor), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(30)
            button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(button)
        }
    }
    
    private func applyConstraints() {
        centralButton.snp_makeConstraints { make in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(offset)
            make.leading.equalTo(view).offset(offset)
            make.trailing.equalTo(view).offset(-offset)
            make.height.equalTo(peripheralButton)
        }
        peripheralButton.snp_makeConstraints { make in
            make.top.equalTo(centralButton.snp_bottom).offset(offset)
            make.leading.trailing.equalTo(centralButton)
            make.bottom.equalTo(view).offset(-offset)
        }
    }
    
    // MARK: Target Actions
    
    @objc private func buttonTapped(button: UIButton) {
        if button == centralButton {
            navigationController?.pushViewController(CentralViewController(), animated: true)
        } else if button == peripheralButton {
            navigationController?.pushViewController(PeripheralViewController(), animated: true)
        }
    }
    
}
