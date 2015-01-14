//
//  FeedViewController.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/14/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class FeedViewController: UIKit.UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UserManager.getUsersDataWithSuccess { (usersData) -> Void in
        //
        //            let json = JSON(data: usersData)
        //
        //            if let userArray = json["results"].arrayValue {
        //                var users = [UserModel]()
        //
        //                for userDict in userArray {
        //                    var email: String? = userDict["email"].stringValue
        //                    var username: String? = userDict["username"].stringValue
        //
        //                    var user = UserModel(email: email, username: username)
        //                    users.append(user)
        //                }
        //                
        //                println(users)
        //            }
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
