//
//  LoginViewController
//  ingenWitty
//
//  Created by cortanaOS on 1/10/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import UIKit

class LoginViewController: UIKit.UIViewController {
    
    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var errorLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Event Handlers
    @IBAction func loginUser(sender : AnyObject) {
        if usernameField.text.isEmpty || passwordField.text.isEmpty {
            self.errorLabel.text = "Please fill up all the fields"
        }else{
            self.errorLabel.text = ""
            var params = [String: String]()
            params["username"] = self.usernameField.text
            params["password"] = self.passwordField.text
            
            Client.authenticateWithCredentials(params, completion:{(data, error) -> Void in
                if (data != nil){
                    dispatch_async(dispatch_get_main_queue()) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("feedViewController") as UIViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorLabel.text = "Login Failed"
                    }
                }
            })
        }
    }
    
}

