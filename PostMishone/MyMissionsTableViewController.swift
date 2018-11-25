//
//  MyMissionsTableViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-07.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase


class MyMissionsTableViewController: UITableViewController {
    var ref: DatabaseReference!
    var myMissions = [String]()
    var missionIDS = [String]()
    let userID = Auth.auth().currentUser!.uid
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        ref = Database.database().reference().child("Users").child(userID).child("MissionPosts") // Firebase Reference
//
//        ref?.observeSingleEvent(of: .value, with: { snapshot in
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                let missionID = snap.value as! String
//                print(missionID)
//                self.missionIDS.append(missionID)
//                print(self.missionIDS.count)
//            }
//        })
//        print("inside MyMissionsTableView")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("Users").child(userID).child("MissionPosts") // Firebase Reference

        ref?.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let missionID = snap.value as! String
                print(missionID)
                self.missionIDS.append(missionID)
                print(self.missionIDS.count)
                self.tableView.reloadData()
            }
        })
        print("inside MyMissionsTableView")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionIDS.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = missionIDS[indexPath.row]

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
