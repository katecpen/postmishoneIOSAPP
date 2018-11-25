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
    
    @IBAction func chat(_ sender: UIButton) {
      //  self.performSegue(withIdentifier: "toChat", sender: self)
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
