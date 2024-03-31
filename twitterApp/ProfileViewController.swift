//
//  ProfileViewController.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/09/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
        
    
    
    @IBOutlet weak var NameText: UILabel!
    @IBOutlet weak var ProfileText: UILabel!
    @IBOutlet weak var IDText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
   
    
    let db = Firestore.firestore()
    var documents:[DocumentSnapshot] = []
    let uid = Auth.auth().currentUser?.uid
    var likeCheck = false
    
    
    

    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomView")
        db.collection("tweet").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.data())")
                }
            }
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       
     

        if let currentUser = Auth.auth().currentUser {
                    let userId = currentUser.uid
                    let docRef = db.collection("user").document(userId)
            
            IDText.text = "ID:\(userId)"
                    
                    docRef.getDocument { document, error in
                        if let document = document, document.exists {
                            if let name = document["Name"] as? String {
                                self.NameText.text = name
                            }else{
                                self.NameText.text = ""
                            }
                            if let profile = document["Profile"] as? String{
                                self.ProfileText.text = profile
                            }else{
                                self.ProfileText.text = ""
                            }
                            if var follow = document["follow"] as? [String]{
                                var followCount = follow.count
                                self.followCount.text = String(followCount)
                            }
                            if var follow = document["follower"] as? [String]{
                                var followerCount = follow.count
                                self.followerCount.text = String(followerCount)
                            }
                        } else {
                            print("Document does not exist")
                        }
                        
                    }
                } else {
                    print("User not signed in")
            }
        
        
        
        
        
        FirebaseView()
        
    }
    
    func FirebaseView(){
        
        let MyTweet = db.collection("tweet")
        
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
            MyTweet.whereField("id", isEqualTo: userId).order(by: "date", descending: true).getDocuments {
                QuerySnapshot, Error in
                if let Error = Error {
                    print(Error)
                }else{
                    self.documents = QuerySnapshot!.documents
                    self.tableView.reloadData()
                }
            }
        }else{
            print("Error")
        }
    }
    
    func tableReloard(){
        tableView.reloadData()
    }
    
    func FirebaseReload(){
        let user = Auth.auth().currentUser
        let userId = user?.uid
        db.collection("tweet").whereField("id", isEqualTo: userId).order(by: "date", descending: true).getDocuments { [weak self] QuerySnapshot, Error in
            guard let self = self else { return }
            
            if let Error = Error{
                print("Error getting documents: \(Error)")
            } else {
                self.documents = QuerySnapshot!.documents
                print(self.documents)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
        }catch{
            print("error")
        }
        
        performSegue(withIdentifier: "login", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomView", for: indexPath) as! CustomTableViewCell
        
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
        let likeCount = data?["likeCount"] as? String
        cell.TweetLike.text! = likeCount ?? "0"
        
        cell.LikeButton.tag = indexPath.row
        cell.LikeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        
        
        
        let postID = documents[sender.tag].documentID
        let tweetData = documents[sender.tag].data()
        var likedBy = ["likes":FieldValue.arrayUnion([uid ?? "No ID"])]
        db.collection("tweet").document(postID).updateData(likedBy){error in
            if let error = error{
                print(error)
            }else{
                self.FirebaseReload()
            }
        }
        LikeCheck(postID: postID)
        if self.likeCheck == false{
            updateIncrementLikeCount(postID: postID)
        }
        if self.likeCheck == true{
            updateDecrementLikeCount(postID: postID)
        }
        
        func LikeCheck(postID:String){
            db.collection("tweet").document(postID).getDocument { DocumentSnapshot, Error in
                if let Error = Error{
                    print(Error)
                }else{
                    let document = DocumentSnapshot?.data()
                    let like = document?["likes"] as? [String]
                    self.likeCheck = containsString(array: like ?? ["No Array"], searchID: self.uid ?? "No ID")
                    print(self.likeCheck)
                }
            }
        }
        
        func updateIncrementLikeCount(postID:String){
            db.collection("tweet").document(postID).getDocument { DocumentSnapshot, Error in
                if let Error = Error{
                    print(Error)
                }else{
                    let document = DocumentSnapshot?.data()
                    let like = document?["likes"] as? [String]
                    let likeCount = like?.count ?? 0
                    print(likeCount)
                    
                    updateFirestore(postID: postID, likeCount: likeCount)
                }
            }
        }
        
        func DeleteID(postID:String){
            let IdData = ["likes":FieldValue.arrayRemove([uid])]
            db.collection("tweet").document(postID).updateData(IdData) { Error in
                if let Error = Error {
                    print(Error)
                }else{
                    print("Sucsess")
                }
            }
        }
        
        func updateDecrementLikeCount(postID:String){
            DeleteID(postID: postID)
            db.collection("tweet").document(postID).getDocument { DocumentSnapshot, Error in
                if let Error = Error{
                    print(Error)
                }else{
                    let document = DocumentSnapshot?.data()
                    let like = document?["likes"] as? [String]
                    let likeCount = like?.count ?? 0
                    print(likeCount)
                    
                    updateFirestore(postID: postID, likeCount: likeCount)
                }
            }
        }
        
        func updateFirestore(postID:String,likeCount:Int){
            db.collection("tweet").document(postID).updateData(["likeCount":String(likeCount)]){error in
                if let error = error{
                    print(error)
                }else{
                    self.FirebaseReload()
                }
            }
        }
        
        
        
        func containsString(array:[String],searchID:String) -> Bool{
            for ids in array{
               if ids == searchID{
                   return true
               }
            }
            return false
        }
        
    }
    


}

class ProfileEditedViewController: UIViewController,UITextFieldDelegate{
    
    let db = Firestore.firestore()
    let ProfileView = ProfileViewController.self
    
    
    
    @IBOutlet weak var ProfileText: UITextField!
    
    override func viewDidLoad() {
        ProfileText.delegate = self
    }
    
    
    @IBAction func DoneButton(_ sender: Any) {
        self.db.collection("user").document(Auth.auth().currentUser!.uid).updateData(["Profile" : ProfileText.text!])
        dismiss(animated: true)
        self.view.isHidden = true
    }
    
    
    @IBAction func CanselButton(_ sender: Any) {
        dismiss(animated: true)
        self.view.isHidden = true
    }
    
    
}
