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
    var longitude = 0.0
    var latitude = 0.0
    var timeStamp = 0
    
    @IBOutlet weak var missionTitleLabel: UILabel!
    @IBOutlet weak var missionSubtitleLabel: UILabel!
    @IBOutlet weak var missionSubtitleTextView: UITextView!
    @IBOutlet weak var missionRewardLabel: UILabel!
    @IBOutlet weak var missionPosterLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() // Firebase Reference
        //        ref.child("users").child ///TODO: current does not pull anything from the database
        missionTitleLabel.text = missionTitle
        missionSubtitleLabel.text = subtitle
        missionSubtitleTextView.text = subtitle
        missionRewardLabel.text = reward
        missionPosterLabel.text = posterID
        
    }
    

    @IBAction func deleteMission(_ sender: Any) {
        print("deleteMission")
        // Remove from https://postmishone.firebaseio.com/users/(currentuserid)/
        self.ref.child("Users").child(posterID).child("MissionPosts").child(missionID).removeValue()
        
        deleteVisibleMissionPost()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func acceptMission(_ sender: Any) {
        print("accept mission")
        
        self.ref.child("AcceptedMissions").child(missionID).setValue(["Latitude": latitude, "Longitude": longitude, "UserID": posterID, "acceptorID" : userID, "timeStamp": timeStamp, "missionName": missionTitle, "missionDescription": subtitle, "reward": reward, "missionID": missionID])
        
         deleteVisibleMissionPost()
        
    ref?.child("Users").child(userID).child("AcceptedMissions").child(missionID).setValue(missionID)
        
        ref?.child("Users").child(userID).child("MissionHistory").child(missionID).setValue(missionID)

        
    }
    
    func deleteVisibleMissionPost() {
        // Remove from https://postmishone.firebaseio.com/PostedMissions
        self.ref.child("PostedMissions").child(missionID).removeValue()
        

    }
}
