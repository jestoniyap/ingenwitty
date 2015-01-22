//
//  UserProfileManager.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/12/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class UserProfileManager {
    class func getUserProfileDataWithSuccess(success: ((userProfileData: NSData!) -> Void)){
        Client.getRequestFromResource("api/userprofile", completion:{(data, error) -> Void in
            if let urlData = data{
                success(userProfileData: urlData)
            }
        })
    }
}