//
//  SearchMission.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-24.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase


class SearchMission: UIViewController {
    var ref: DatabaseReference!
    var searchedMissions = [Mission]()
    var didSelectCategory = false
    var selectedCategory = ""
    var selectedMission = Mission(missionName: "", missionDescription: "", missionReward: "", posterID: "", missionCategory: "Other", reward: "", missionID: "", latitude: 0.0, longitude: 0.0)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var missionTitleLabel: UILabel!
    @IBOutlet weak var missionDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() //Firebase Reference

    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

extension SearchMission: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = searchedMissions[indexPath.row].missionName
        cell?.detailTextLabel?.text = searchedMissions[indexPath.row].missionDescription
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMission = searchedMissions[indexPath.row]
        performSegue(withIdentifier: "toMissionDescription", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? MissionDescriptionViewController
        destination?.missionTitle = selectedMission.missionName
        destination?.subtitle = selectedMission.missionDescription
        destination?.posterID = selectedMission.posterID
        destination?.reward = selectedMission.reward
        destination?.missionID = selectedMission.missionID
        destination?.latitude = selectedMission.latitude
        destination?.longitude = selectedMission.longitude
    }
}



extension SearchMission: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMissions.removeAll()
        if !searchText.isEmpty {
            ref.child("PostedMissions").queryOrdered(byChild: "missionName").queryStarting(atValue: searchText).queryEnding(atValue: searchText + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children {
                    print("FOR LOOP")
                    let snap = child as! DataSnapshot
                    if let dic = snap.value as? [String:Any], let missionName = dic["missionName"] as? String, let missionDescription = dic["missionDescription"] as? String, let reward = dic["reward"] as? String, let category = dic["category"] as? String, let posterID = dic["UserID"] as? String, let missionID = dic["missionID"] as? String, let latitude = dic["Latitude"] as? Double, let longitude = dic["Longitude"] as? Double {
                        if(self.didSelectCategory) {
                            print("didSelectCategory")
                            if(self.selectedCategory == category) {
                                self.searchedMissions.append(Mission(missionName: missionName, missionDescription: missionDescription, missionReward: reward, posterID: posterID, missionCategory: category, reward: reward, missionID: missionID, latitude: latitude, longitude: longitude))
                            }
                        }
                        else {
                                self.searchedMissions.append(Mission(missionName: missionName, missionDescription: missionDescription, missionReward: reward, posterID: posterID, missionCategory: category, reward: reward, missionID: missionID, latitude: latitude, longitude: longitude))
                        }


                        print(self.searchedMissions.count)
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            switch selectedScope {
            case 0:
                print("all")
                searchBar.endEditing(true)
                searchedMissions.removeAll()
                searchBar.text = ""
                tableView.reloadData()
                didSelectCategory = false
                break
            case 1:
                print("deliver")
                changedCategoryReconfig()
                selectedCategory = "Deliver"

            case 2:
                print("partner")
                changedCategoryReconfig()
                selectedCategory = "Partner"

            case 3:
                print("rent")
                changedCategoryReconfig()
                selectedCategory = "Rent"
            case 4:
                print("other")
                changedCategoryReconfig()
                selectedCategory = "Other"
            default:
                didSelectCategory = false
                break
            }
        }
    
    func changedCategoryReconfig() {
        searchBar.endEditing(true)
        searchedMissions.removeAll()
        searchBar.text = ""
        tableView.reloadData()
        didSelectCategory = true

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        tableView.reloadData()
    }
}

class Mission {
    let missionName: String
    let missionDescription: String
    let missionReward: String
    let missionCategory: String
    let posterID: String
    let reward: String
    let missionID: String
    let latitude: Double
    let longitude: Double
    
    init(missionName: String, missionDescription: String, missionReward: String, posterID: String, missionCategory: String, reward: String, missionID: String, latitude: Double, longitude: Double ) {
        self.missionName = missionName
        self.missionDescription = missionDescription
        self.missionReward = missionReward
        self.missionCategory = missionCategory
        self.posterID = posterID
        self.reward = reward
        self.missionID = missionID
        self.latitude = latitude
        self.longitude = longitude
    }
}
