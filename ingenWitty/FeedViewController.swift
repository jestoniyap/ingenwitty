//
//  FeedViewController.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/14/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var imageCache = [String : UIImage]()
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFeedTable:", name: "reloadFeedTable", object: nil)
        self.loadFeedTable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadFeedTable", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NSNotification
    func reloadFeedTable(notification: NSNotification) {
        self.loadFeedTable()
    }
    
    // Methods
    func loadFeedTable() {
        PostManager.getPostsDataWithSuccess { (postsData) -> Void in
            
            self.posts = [PostModel]()
            
            let json = JSON(data: postsData)
            
            if let postArray = json["results"].arrayValue {
                
                for postDict in postArray {
                    var postId: String? = postDict["pk"].stringValue
                    var message: String? = postDict["message"].stringValue
                    var createdOn: String? = postDict["created_on"].stringValue
                    var likes: String? = postDict["likes"].stringValue
                    var comments: String? = postDict["comments"].stringValue
                    
                    var user = UserModel(userId: postDict["user"]["pk"].stringValue, firstName: postDict["user"]["first_name"].stringValue, lastName: postDict["user"]["last_name"].stringValue, email: postDict["user"]["email"].stringValue, username: postDict["user"]["username"].stringValue)
                    
                    var userprofile = UserProfileModel(userprofileId: postDict["author"]["pk"].stringValue, user: user, createdOn: postDict["author"]["created_on"].stringValue, picture: postDict["author"]["picture"].stringValue)
                    var author: UserProfileModel = userprofile
                    
                    var post = PostModel(postId:postId, message: message, createdOn: createdOn, author: author, likes: likes, comments: comments)
                    self.posts.append(post)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    // Event Handlers
    @IBAction func commentPost(sender : UIButton) {
        dispatch_async(dispatch_get_main_queue()) {
            let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(pointInTable)
            let cell: FeedCell = self.tableView.cellForRowAtIndexPath(indexPath!) as FeedCell
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("commentViewController") as CommentViewController
            vc.postId = cell.postId!
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    // UITableController
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: FeedCell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as FeedCell
        
        if self.posts.count < 1{
            return cell
        }
        
        cell.commentButton.addTarget(self, action: "commentPost:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.messageLabel.text = self.posts[indexPath.row].message
        cell.likesLabel.text = self.posts[indexPath.row].likes + " Likes"
        cell.commentsLabel.text = self.posts[indexPath.row].comments + " Comments"
        cell.postId = self.posts[indexPath.row].postId
        
        var imageUrlString = self.posts[indexPath.row].author.picture
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
