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
        
    }
    
}

