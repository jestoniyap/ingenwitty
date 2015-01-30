//
//  ProfileViewController.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/19/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var firstNameLabel : UILabel!
    @IBOutlet var lastNameLabel : UILabel!
    @IBOutlet var pictureImageView : UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var imagePicker = UIImagePickerController()
    
    var imageCache = [String : UIImage]()
    var posts = [PostModel]()
    var isFromUpload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromUpload {
            self.isFromUpload = false
        }else{
            self.loadUserProfile()
            self.loadFeedTable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    func loadUserProfile(){
        UserProfileManager.getUserProfileDataWithSuccess { (userProfileData) -> Void in
            
            let json = JSON(data: userProfileData)
            
            var user = UserModel(userId: json["user"]["pk"].stringValue, firstName: json["user"]["first_name"].stringValue, lastName: json["user"]["last_name"].stringValue, email: json["user"]["email"].stringValue, username: json["user"]["username"].stringValue)
            
            var userprofile = UserProfileModel(userprofileId: json["pk"].stringValue, user: user, createdOn: json["created_on"].stringValue, picture: json["picture"].stringValue)
            
            var imageUrlString = userprofile.picture
            var image = self.imageCache[imageUrlString]
            
            if (image == nil){
                Client.downloadImageAsync(imageUrlString, completion:{(image, error) -> Void in
                    self.imageCache[imageUrlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        self.pictureImageView.image = image
                    })
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.pictureImageView.image = image
                })
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.firstNameLabel.text = userprofile.user.firstName
                self.lastNameLabel.text = userprofile.user.lastName
            }
        }
    }
    
    func loadFeedTable() {
        PostManager.getUserPostsDataWithSuccess { (postsData) -> Void in
            
            self.posts = [PostModel]()
            
            let json = JSON(data: postsData)
            
            if let postArray = json.arrayValue {
                
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
    
    // MARK: Event Handlers
    @IBAction func logoutUser(sender : AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "accessToken")
        NSNotificationCenter.defaultCenter().postNotificationName("dismissMainTabBarController", object: nil)
    }

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
    
    @IBAction func changeProfilePicture(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Change Profile Picture", preferredStyle: .ActionSheet)
        
        self.isFromUpload = true

        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.imagePicker.delegate = self
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let fromPhotoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imagePicker.delegate = self
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let fromSavedPhotosAction = UIAlertAction(title: "Saved Photos", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            self.imagePicker.delegate = self
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.isFromUpload = false
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(fromPhotoLibraryAction)
        optionMenu.addAction(fromSavedPhotosAction)
        optionMenu.addAction(cancelAction)
    
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: UITableController
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
    
    // MARK: UIImagePicker
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        let tempImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        UserProfileManager.updateUserProfilePictureWithSuccess(tempImage, success: { (userProfileData) -> Void in
            self.isFromUpload = true
            self.loadUserProfile()
            self.loadFeedTable()
        })
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
