//
//  LoginViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "LoginViewController"

        //changes*************
        let button = FBSDKLoginButton()
        view.addSubview(button)
        button.frame = CGRect(x: 16, y: 450, width: view.frame.width - 32, height: 50 )
    }
    
//    func loginButtonDidLogOut(_ button: FBSDKLoginButton) {
//        print("Facebook logged out")
//    }
//
//    func loginButton(_ button:FBSDKLoginButton) {
//        if button.accessibilityActivate() {
//            self.navigationController?.popViewController(animated: false)
//            print("Log in success")
//        } else {
//            print("error")
//            return
//        }
//    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        // Check user authentication, bring to mainAppScreen when ready
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil && error == nil {
                self.navigationController?.popViewController(animated: false)
                print("Log in success")
                
            }
            else {
                print(error!)
                print(self.emailTextField.text!)
                print(self.passwordTextField.text!)
            }
        }

        
    }

}
