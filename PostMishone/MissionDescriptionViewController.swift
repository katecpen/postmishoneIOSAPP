//
//  MissionDescriptionViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-04.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase

class MissionDescriptionViewController: UIViewController {
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser!.uid
    var missionTitle = ""
    var subtitle = ""
    var reward = ""
    var posterID = ""
    var missionID = ""
    
    
    @IBOutlet weak var missionTitleLabel: UILabel!
    @IBOutlet weak var missionSubtitleTextView: UITextView!
    @IBOutlet weak var missionRewardLabel: UILabel!
    
    @IBOutlet weak var userPicOfPost: UIImageView! // user picture of the poster (newly added)
    @IBOutlet weak var usernameOfPost: UILabel! // username of the poster (newly added)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() // Firebase Reference
        //        ref.child("users").child ///TODO: current does not pull anything from the database
        missionTitleLabel.text = missionTitle
        missionSubtitleTextView.text = subtitle
        missionRewardLabel.text = reward
        
        //changes@@@@@@@@@@@@@@@@@@@@@@@
        // reference to firebase storage
        let store = Storage.storage()
        // refer our storage service
        let storeRef = store.reference(forURL: "gs://postmishone.appspot.com")
        // access files and paths
        let userProfilesRef = storeRef.child("images/profiles/\(posterID)")
        
        // fetch the username
        let username = Database.database().reference().child("Users").child(userID)
        
        username.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["username"] as? String ?? ""
            self.usernameOfPost.text = name
        })
    
        
        // check if the picture exist in the database
        userProfilesRef.getData(maxSize: 1*1024*1024) { (data, error) in
            if data != nil && error == nil{
                self.userPicOfPost.image = UIImage(data: data!)
            } else {
                let none = Storage.storage().reference(forURL: "gs://postmishone.appspot.com").child("images/profiles/yolo123empty.jpg")
                none.getData(maxSize: 1*1024*1024, completion: { (data_none, error_none) in
                    if error_none != nil {
                        print("error fetching the none profile pic")
                    } else {
                        self.userPicOfPost.image = UIImage(data: data_none!)
                    }
                })
            }
            
        }
        
        
        
    }
    

    @IBAction func deleteMission(_ sender: Any) {
        print("deleteMission")
         // Remove from https://postmishone.firebaseio.com/PostedMissions
        self.ref.child("PostedMissions").child(missionID).removeValue()
        
        // Remove from https://postmishone.firebaseio.com/users/(currentuserid)/
        self.ref.child("Users").child(posterID).child("MissionPosts").child(missionID).removeValue()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func acceptMission(_ sender: Any) {
        print("accept mission")
        
        ref?.child("Users").child(userID).child("AcceptedMissions").child(missionID).setValue(missionID)
        
        
    }
    
}
