//
//  FollowViewController.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/10/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FollowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var followTable: UITableView!
    
    let db = Firestore.firestore()
    var documents:[DocumentSnapshot] = []
    var followCount = 0
    var id = ""
    var names:[String] = []
    var profiles:[String] = []
    var follow:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    followTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ResultView")
    
    followTable.delegate = self
    followTable.dataSource = self

        followCountFunc()
        
        print(id)
        print(followCount)
        print("\(follow[0])")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        followCountFunc()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultView", for: indexPath) as! TableViewCell
        
        
        cell.SearchName.text = follow[indexPath.row]
        return cell
    }
    
    func followCountFunc(){
        db.collection("user").document(id).getDocument { DocumentSnapshot, Error in
            if let Error = Error{
                print(Error)
            }
            if let document = DocumentSnapshot?.data(){
                self.follow = document["follow"] as? [String] ?? ["No arr"]
                self.followCount = self.follow.count
            }
        }
        followTable.reloadData()
    }
    
    func searchUser(){
        for i in 0...followCount{
            var id = follow[i]
            db.collection("user").document(id).getDocument { DocumentSnapshot, Error in
                if let Error = Error{
                    print(Error)
                }
                if let document = DocumentSnapshot?.data(){
                    self.names = document["Name"] as? [String] ?? ["No Name"]
                    self.profiles = document["Profile"] as? [String] ?? ["No Profile"]
                    print(self.names)
                    print(self.profiles)
                }
            }
        }
    }
    
    @IBAction func backProfileButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
