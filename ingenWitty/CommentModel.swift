//
//  CommentModel.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/21/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class CommentModel: NSObject, Printable {
    let commentId: String
    let message: String
    let createdOn: String
    let author: UserProfileModel
    let post: PostModel
    
    override var description: String {
        return "Comment Id: \(commentId), Message: \(message), Author: \(author), Created On: \(createdOn)\n, Post: \(post)"
    }
    
    init(commentId: String?, message: String?, createdOn: String?, author: UserProfileModel, post: PostModel) {
        self.commentId = commentId ?? ""
        self.message = message ?? ""
        self.createdOn = createdOn ?? ""
        self.author = author
        self.post = post
    }
}