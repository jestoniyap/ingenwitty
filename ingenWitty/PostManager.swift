//
//  PostManager.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/16/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class PostManager {
    // Post
    class func getPostsDataWithSuccess(success: ((postsData: NSData!) -> Void)){
        Client.getRequestFromResource("posts", completion:{(data, error) -> Void in
            if let urlData = data{
                success(postsData: urlData)
            }
        })
    }
    
    // Post
    class func getUserPostsDataWithSuccess(success: ((postsData: NSData!) -> Void)){
        Client.getRequestFromResource("api/posts", completion:{(data, error) -> Void in
            if let urlData = data{
                success(postsData: urlData)
            }
        })
    }
    
    class func createPostDataWithSuccess(params: Dictionary<String, String>, success: ((postData: NSData!) -> Void)){
        Client.postRequestToResource("api/posts", params: params, completion:{(data, error) -> Void in
            if let urlData = data{
                success(postData: urlData)
            }
        })
    }
    
    // Like
    class func toggleLikeWithSuccess(params: Dictionary<String, String>, success: ((postsData: NSData!) -> Void)){
        Client.postRequestToResource("api/toggle-like", params: params, completion:{(data, error) -> Void in
            if let urlData = data{
                success(postsData: urlData)
            }
        })
    }
    
    // Comment
    class func getCommentsDataOfPostWithSuccess(args: String, success: ((commentsData: NSData!) -> Void)){
        var resource: String
        if args != ""{
            resource = "api/comments/" + args
        }else{
            resource = "api/comments"
        }
        Client.getRequestFromResource(resource, completion:{(data, error) -> Void in
            if let urlData = data{
                success(commentsData: urlData)
            }
        })
    }
    
    class func createCommentDataWithSuccess(args: String, params: Dictionary<String, String>, success: ((commentData: NSData!) -> Void)){
        var resource: String
        if args != ""{
            resource = "api/comments/" + args
        }else{
            resource = "api/comments"
        }
        Client.postRequestToResource(resource, params: params, completion:{(data, error) -> Void in
            if let urlData = data{
                success(commentData: urlData)
            }
        })
    }
}