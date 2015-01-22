//
//  CommentViewController.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/21/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var textfieldContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageField : UITextField!
    
    var imageCache = [String : UIImage]()
    var comments = [CommentModel]()
    var postId = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Keyboard stuff.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.loadCommentTable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.messageField.resignFirstResponder()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NSNotification
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant += endFrame?.size.height ?? 0.0
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant -= endFrame?.size.height ?? 0.0
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    // Methods
    func loadCommentTable() {
        PostManager.getCommentsDataOfPostWithSuccess(self.postId) { (postsData) -> Void in
            
            self.comments = [CommentModel]()
            
            let json = JSON(data: postsData)
            
            if let commentArray = json.arrayValue {
                
                for commentDict in commentArray {
                    var commentId: String? = commentDict["pk"].stringValue
                    var message: String? = commentDict["message"].stringValue
                    var createdOn: String? = commentDict["created_on"].stringValue
                    
                    var user = UserModel(userId: commentDict["user"]["pk"].stringValue, firstName: commentDict["user"]["first_name"].stringValue, lastName: commentDict["user"]["last_name"].stringValue, email: commentDict["user"]["email"].stringValue, username: commentDict["user"]["username"].stringValue)
                    
                    var userprofile = UserProfileModel(userprofileId: commentDict["author"]["pk"].stringValue, user: user, createdOn: commentDict["author"]["created_on"].stringValue, picture: commentDict["author"]["picture"].stringValue)
                    var author: UserProfileModel = userprofile
                    
                    var post = PostModel(postId:commentDict["post"]["pk"].stringValue, message: commentDict["post"]["message"].stringValue, createdOn: commentDict["post"]["created_on"].stringValue, author: author, likes: commentDict["post"]["likes"].stringValue, comments: commentDict["post"]["comments"].stringValue)
                    
                    var comment = CommentModel(commentId:commentId, message: message, createdOn: createdOn, author: author, post: post)
                    self.comments.append(comment)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    // Event Handlers
    @IBAction func postStatus(sender : AnyObject) {
        
        if self.messageField.text.isEmpty {
            return
        }
        
        var params = [String: String]()
        params["message"] = self.messageField.text
        
        PostManager.createCommentDataWithSuccess (self.postId, params: params) { (commentData) -> Void in
            
            let json = JSON(data: commentData)
            
            if let commentMessage = json["message"].stringValue {
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadCommentTable()
                    self.messageField.text = ""
                    self.messageField.resignFirstResponder()
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
    
    // UITableController
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CommentCell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as CommentCell
        
        if self.comments.count < 1{
            return cell
        }
        
        cell.messageLabel.text = self.comments[indexPath.row].message
        cell.postId = self.comments[indexPath.row].post.postId
        
        var imageUrlString = self.comments[indexPath.row].author.picture
        var image = self.imageCache[imageUrlString]
        
        if (image == nil){
            Client.downloadImageAsync(imageUrlString, completion:{(image, error) -> Void in
                self.imageCache[imageUrlString] = image
                dispatch_async(dispatch_get_main_queue(), {
                    cell.authorImageView.image = image
                })
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                cell.authorImageView.image = image
            })
        }
        return cell
    }
}