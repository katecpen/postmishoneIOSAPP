//
//  PostMishoneTests.swift
//  PostMishoneTests
//
//  Created by Victor Liang on 2018-11-17.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import XCTest
@testable import PostMishone

    class PostMishoneTests: XCTestCase {
        
       
            
            
        }
 
        
       /* func postMissionPressed(_ sender: Any) {
            let userID = Auth.auth().currentUser!.uid
            let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
            
            print("Describe Mission View Controller:")
            print("lat: ", latitude)
            print("long: ", longitude)
            print("userID: ", userID)
            print("timeStamp: ", timeStamp)
            print("missionNameText: ", missionName.text!)
            print("missionDescription: ", missionDescription.text!)
            print("reward: ", reward.text!)
            
            
            let missionID = ref.child("PostedMissions").childByAutoId().key
            // Add to https://postmishone.firebaseio.com/PostedMissions
            ref?.child("PostedMissions").child(missionID!).setValue(["Latitude": latitude, "Longitude": longitude, "UserID": userID, "timeStamp": timeStamp, "missionName": missionName.text!, "missionDescription": missionDescription.text!, "reward": reward.text!, "missionID": missionID!])
            
            // Add to https://postmishone.firebaseio.com/users/(currentuserid)/
            ref?.child("Users").child(userID).child("MissionPosts").child(missionID!).setValue(missionID!)
            
            
            print("Mission Posted!")
            
            self.navigationController?.popViewController(animated: true)
        }*/
        
        

}
