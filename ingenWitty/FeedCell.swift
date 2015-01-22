//
//  FeedCell.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/16/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class FeedCell : UITableViewCell{
    
    @IBOutlet var likesLabel : UILabel!
    @IBOutlet var commentsLabel : UILabel!
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var commentButton : UIButton!
    @IBOutlet var authorImageView : UIImageView!
    
    var postId: String?
    
    // Event Handlers
    @IBAction func likePost(sender : UIButton) {
        
        var params = [String: String]()
        params["post_id"] = self.postId
        
        PostManager.toggleLikeWithSuccess (params) { (postsData) -> Void in
            if (postsData != nil){
                let json = JSON(data: postsData)
                if let is_liked = json["is_liked"].integerValue {
                    var likeString = "Like"
                    if is_liked > 0 {
                        likeString = "Liked"
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        sender.setTitle(likeString, forState: UIControlState.Normal)
                    }
                }
                if let likes = json["likes"].stringValue {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.likesLabel.text = likes + " Likes"
                    }
                }
            }
        }
    }
    
    
}
