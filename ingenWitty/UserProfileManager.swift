//
//  UserProfileManager.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/12/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation
import UIKit

class UserProfileManager {
    class func getUserProfileDataWithSuccess(success: ((userProfileData: NSData!) -> Void)){
        Client.getRequestFromResource("api/userprofile", completion:{(data, error) -> Void in
            if let urlData = data{
                success(userProfileData: urlData)
            }
        })
    }
    
    class func updateUserProfilePictureWithSuccess(image: UIImage, success: ((userProfileData: NSData!) -> Void)){
        Client.uploadImageToServer(image, completion:{(data, error) -> Void in
            if let urlData = data{
                success(userProfileData: urlData)
            }
        })
    }
}