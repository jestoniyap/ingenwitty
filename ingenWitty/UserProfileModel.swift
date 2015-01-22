//
//  UserProfileModel
//  ingenWitty
//
//  Created by cortanaOS on 1/10/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class UserProfileModel: NSObject, Printable {
    let userprofileId: String
    let createdOn: String
    let user: UserModel
    let picture: String
    
    override var description: String {
        return "User Profile Id: \(userprofileId), User: \(user), Created On: \(createdOn), Picture: \(picture)\n"
    }
    
    init(userprofileId: String?, user: UserModel, createdOn: String?, picture: String?) {
        self.userprofileId = userprofileId ?? ""
        self.createdOn = createdOn ?? ""
        self.user = user
        self.picture = picture ?? ""
    }
}