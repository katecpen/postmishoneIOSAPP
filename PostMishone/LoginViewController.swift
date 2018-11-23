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
import FBSDKLoginKit
import SwiftyJSON


class LoginViewController : UIViewController, FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error.localizedDescription)
            return
        } else if result.isCancelled {
            print("Facebook login cancelled")
            self.navigationController?.popViewController(animated: false)
        } else {
            
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, err) in
            if err != nil {
                print("Problem authenticating with firebase")
                return
            }
            // User is signed in
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(480).height(480)"])?.start {
                (connection, result, err) in
                if err != nil {
                    print("Failed to start graph request", err)
                    return
                }
                let json = JSON(result)
                print(json)
                let userID = Auth.auth().currentUser!.uid
                let values = ["email": json["email"].stringValue, "username": json["name"].stringValue] as [String : Any] // TODO: add username (change password)

                self.registerUserIntoDatabase(userID, values: values as [String : AnyObject])
            }
            
            print("Facebook log in success")
            self.navigationController?.popViewController(animated: false)
            
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook logged out")
    }
    
    private func registerUserIntoDatabase(_ userID: String, values: [String: AnyObject]) {
        // Adding User Info
        let ref = Database.database().reference()
        let usersReference = ref.child("Users").child(userID)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //changes*************
        let button = FBSDKLoginButton()
        view.addSubview(button)
        button.frame = CGRect(x: 16, y: 450, width: view.frame.width - 32, height: 28 )
        button.delegate = self
//        button.readPermissions = ["email", "public_profile"]
    }
    
    
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
