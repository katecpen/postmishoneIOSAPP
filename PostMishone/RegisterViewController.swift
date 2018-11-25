//
//  RegisterViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class RegisterViewController : UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func registerTapped(_ sender: Any) {
        // Set up a new user on our Firebase database
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                let userID = Auth.auth().currentUser!.uid
                let values = ["email": email, "password": password] as [String : Any] // TODO: add username (change password)
                self.registerUserIntoDatabase(userID, values: values as [String : AnyObject])

                self.navigationController?.popViewController(animated: false)
                


                print("Registration Successful")

            } else {
                print("Error registering")
                print(error!)
                
            }
        }
    }
    
    
    //CHANGE THIS TO ADD MORE PROFILE STUFF
    private func registerUserIntoDatabase(_ userID: String, values: [String: AnyObject]) {
        // Adding User Info
        let ref = Database.database().reference()
        let usersReference = ref.child("Users").child(userID)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Successfully Added a New User to the Database")
        })
    }
    
}


