//
//  CommentCell.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/22/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class CommentCell : UITableViewCell{
    
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var authorImageView : UIImageView!
    
    var postId: String?
    
}