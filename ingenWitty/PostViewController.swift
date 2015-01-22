//
//  PostViewController.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/16/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit


class PostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var messageField : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.messageField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.messageField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Event Handlers
    @IBAction func postStatus(sender : AnyObject) {
        
        if self.messageField.text.isEmpty {
            return
        }
        
        var params = [String: String]()
        params["message"] = self.messageField.text
        
        PostManager.createPostDataWithSuccess (params) { (postData) -> Void in
            
            let json = JSON(data: postData)
            
            if let postMessage = json["message"].stringValue {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadFeedTable", object: nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func closeView(sender : AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadFeedTable", object: nil)
        }
    }


}