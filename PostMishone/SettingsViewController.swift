//
//  SettingsViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseStorage
import SwiftyJSON

class SettingsViewController: UIViewController {
    @IBOutlet weak var uiimgvpropic: UIImageView!
    @IBOutlet weak var uiname: UILabel!
    @IBOutlet weak var uiemail: UILabel!
    
    var imagePicker:UIImagePickerController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make profile round
        self.uiimgvpropic.layer.cornerRadius = self.uiimgvpropic.frame.size.width/2
        self.uiimgvpropic.clipsToBounds = true
        
        if FBSDKAccessToken.current() != nil {
            if let user = Auth.auth().currentUser {
                // user signed in
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid
                
                
                self.uiname.text = name
                self.uiemail.text = email
                
                let data = NSData(contentsOf: photoUrl!)
                self.uiimgvpropic.image = UIImage(data: data! as Data)
                
                // reference to firebase storage
                let store = Storage.storage()
                // refer our storage service
                let storeRef = store.reference(forURL: "gs://postmishone.appspot.com")
                // access files and paths
                let userProfilesRef = storeRef.child("images/profiles/\(uid)")
                
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(480).height(480)"])?.start(completionHandler: { (connection, result, err) in
                    if err == nil {
                        let json = result as! [String: AnyObject]
                        ////
                        // Data in memory
                        let FBid = json["id"] as? String
                        print(FBid)
                        
                        let nsurl = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                        let imageData = UIImage(data: NSData(contentsOf: nsurl! as URL)! as Data)
                        guard let imgData = imageData?.jpegData(compressionQuality: 0.75) else {return}
                        
                        // Upload the file to the path "images/rivers.jpg"
                        let uploadTask = userProfilesRef.putData(imgData, metadata: nil) { (metadata, error) in
                            guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                print("Error metadata")
                                return
                            }
                            // Metadata contains file metadata such as size, content-type.
                            let size = metadata.size
                            // You can also access to download URL after upload.
                            userProfilesRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    print("Error downloadURL")
                                    return
                                }
                            }
                        }
                        self.uiimgvpropic.image = UIImage(data: imgData)
                        ////
                    } else {
                        print("Failed to start graph request", err)
                        return
                    }
                })
            } else {
                // no user is signed in
                print("No user is signed in")
            }
        } else {
            // do these if it is not signed in using facebook
            let user = Auth.auth().currentUser
            let name = user?.displayName
            let email = user?.email
            self.uiname.text = name
            self.uiemail.text = email
        }
        view.accessibilityIdentifier = "SettingsViewController" // Identifier for UI Testing
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
    
    @IBAction func handleLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        FBSDKAccessToken.setCurrent(nil)
        self.dismiss(animated: true, completion: nil)
        print("Log out success")
    }
    
    @IBAction func imagePickerTapped(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ pciker: UIImagePickerController) {
        pciker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uiimgvpropic.image = pickedImage
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
