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
    var isSearching = false
    
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
}

extension SearchMission: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMissions.removeAll()
        if !searchText.isEmpty {
            ref.child("PostedMissions").queryOrdered(byChild: "missionName").queryStarting(atValue: searchText).queryEnding(atValue: searchText + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children {
                    print("FOR LOOP")
                    let snap = child as! DataSnapshot
                    if let dic = snap.value as? [String:Any], let missionName = dic["missionName"] as? String, let missionDescription = dic["missionDescription"] as? String, let reward = dic["reward"] as? String {
                        self.searchedMissions.append(Mission(missionName: missionName, missionDescription: missionDescription, missionReward: reward))
                        print(self.searchedMissions.count)
                        self.tableView.reloadData()
                    }
                }
            }
        }

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
    
    init(missionName: String, missionDescription: String, missionReward: String) {
        self.missionName = missionName
        self.missionDescription = missionDescription
        self.missionReward = missionReward
    }
}
