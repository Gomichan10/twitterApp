//
//  SearchViewController.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/10/05.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    let item = ["とっちゃん","gaga","Gomi"]
    let db = Firestore.firestore()
    var name = ""
    var profile = ""
    
 
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var ResultTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ResultView")
    
    ResultTable.delegate = self
    ResultTable.dataSource = self
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if name == ""{
            return 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultView", for: indexPath) as! TableViewCell
        cell.SearchName.text = name
        cell.SearchProfile.text = profile
        cell.SearchID.text = SearchField.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ResultTable.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "SearchProfile", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchProfile" {
            let SearchVC = segue.destination as! SearchResultViewContoller
            SearchVC.id = SearchField.text!
        }
    }
    

    
    @IBAction func SearchButton(_ sender: Any) {
        
        SearchView()
        
    }
    
    func SearchView(){
        let SearchId = SearchField.text ?? ""
        print(SearchId)
        if SearchId != ""{
            db.collection("user").document(SearchId).getDocument() { DocumentSnapshot, Error in
                if let Error = Error {
                    print(Error)
                }else{
                    let document = DocumentSnapshot
                    if let name = document?["Name"] as? String{
                        self.name = name
                    }else{
                        print("Error")
                    }
                    if let profile = document?["Profile"] as? String{
                        self.profile = profile
                    }else{
                        print("Error")
                    }
                
                    self.ResultTable.reloadData()
                    
                }
            }
        }else{
            print("Empty")
        }
        
    }
    
}

class SearchResultViewContoller:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    @IBOutlet weak var ResultName: UILabel!
    @IBOutlet weak var ResultID: UILabel!
    @IBOutlet weak var ResultProfile: UILabel!
    @IBOutlet weak var ResultTable: UITableView!
    @IBOutlet weak var FollowCount: UILabel!
    @IBOutlet weak var FollowerCount: UILabel!
    @IBOutlet weak var followButton: UIButton!
    var documents:[DocumentSnapshot] = []
    
    let db = Firestore.firestore()
    var id = ""
    var followCheck = false
    

    
    override func viewDidLoad() {
        ResultTable.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomView")
        FirebaseView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let user = Auth.auth().currentUser
        
        db.collection("user").document(id).getDocument { DocumentSnapshot, Error in
            if let Error = Error{
                print(Error)
            }else{
                let docment = DocumentSnapshot
                let name = docment?["Name"] as? String
                let follow = docment?["follow"] as? [String]
                let follower = docment?["follower"] as? [String]
                let followCount = follow?.count
                let followerCount = follower?.count
                if follower != nil{
                    self.followCheck = self.containsString(array: follower!, searchString: user!.uid)
                    print(self.followCheck)
                }
                print(self.followCheck)
                if self.followCheck == true{
                    self.followButton.setTitle("フォロー中", for: .normal)
                    self.followButton.tintColor = UIColor.gray
                }else{
                    self.followButton.setTitle("フォロー", for: .normal)
                    self.followButton.tintColor = UIColor.link
                }
                self.ResultName.text = name
                let profile = docment?["Profile"] as? String
                self.ResultProfile.text = profile
                self.ResultID.text = "ID:\(self.id)"
                self.FollowCount.text = String(followCount ?? 0)
                self.FollowerCount.text = String(followerCount ?? 0)
            }
        }
        FirebaseView()
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true)
        self.view.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResultTable.dequeueReusableCell(withIdentifier: "CustomView", for: indexPath) as! CustomTableViewCell
        
        let data = documents[indexPath.row].data()
        let timeStamp = data?["date"] as? Timestamp
        let time = timeStamp?.dateValue()
        var stringDate = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = time {
            stringDate = dateFormatter.string(from: date)
        }else{
            print("error")
        }
        
        cell.TweetText.text! = data?["tweet"] as? String ?? "No Data"
        cell.TweetName.text! = data?["name"] as? String ?? "No Data"
        cell.TweetTime.text! = stringDate
        return cell
    }
    
    
    @IBAction func Follow(_ sender: Any) {
        if followCheck == true{
            if let user = Auth.auth().currentUser{
                let uid = user.uid
                print(uid)
                let followerData = ["follower":FieldValue.arrayRemove([uid])]
                db.collection("user").document(id).updateData(followerData){ error in
                    if let error = error{
                        print(error)
                    }else{
                        print("success")
                    }
                }
                let followData = ["follow":FieldValue.arrayRemove([id])]
                db.collection("user").document(uid).updateData(followData){ error in
                    if let error = error {
                        print(error)
                    }else{
                        print("success")
                    }
                }
            }else{
                print("error")
            }
        }else{
            if let user = Auth.auth().currentUser{
                let uid = user.uid
                print(uid)
                let followerData = ["follower":FieldValue.arrayUnion([uid])]
                db.collection("user").document(id).updateData(followerData){ error in
                    if let error = error{
                        print(error)
                    }else{
                        print("success")
                    }
                }
                let followData = ["follow":FieldValue.arrayUnion([id])]
                db.collection("user").document(uid).updateData(followData){ error in
                    if let error = error {
                        print(error)
                    }else{
                        print("success")
                    }
                }
            }else{
                print("error")
            }
        }
        
        self.viewDidAppear(true)
    }
    
    
    
    func FirebaseView(){
        
        
        
        db.collection("tweet").whereField("id", isEqualTo: id).order(by: "date", descending: true).getDocuments {
            QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
            }else{
                self.documents = QuerySnapshot!.documents
                self.ResultTable.reloadData()
            }
        }
        
    }
    
    func containsString(array: [String], searchString: String) -> Bool {
      for item in array {
        if item == searchString {
          return true
        }
      }
      return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followList"{
            let followVC = segue.destination as! FollowViewController
            followVC.id = id
        }
    }
    
    @IBAction func followList(_ sender: Any) {
        performSegue(withIdentifier: "followList", sender: nil)
    }
    
}
