//
//  PostModel.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/16/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class PostModel: NSObject, Printable {
    let postId: String
    let message: String
    let createdOn: String
    let author: UserProfileModel
    let likes: String
    let comments: String
    
    override var description: String {
        return "Post Id: \(postId), Message: \(message), Author: \(author), Created On: \(createdOn), Likes: \(likes), Comments: \(comments)\n"
    }
    
    init(postId: String?, message: String?, createdOn: String?, author: UserProfileModel, likes: String?, comments: String?) {
        self.postId = postId ?? ""
        self.message = message ?? ""
        self.createdOn = createdOn ?? ""
        self.author = author
        self.likes = likes ?? "0"
        self.comments = comments ?? "0"
    }
}