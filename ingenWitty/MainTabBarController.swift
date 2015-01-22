//
//  MainTabBarController.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/15/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismissMainTabBarController:", name: "dismissMainTabBarController", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NSNotification
    func dismissMainTabBarController(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}