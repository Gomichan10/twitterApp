//
//  TimeLineViewController.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/10/03.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TimeLineViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    
    
    
    let item = ["item1","item2","item3","item4","item5"]
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var documents:[DocumentSnapshot] = []
    var likeCount = 0
    var likeCheck = false
    
    
    
    @IBOutlet weak var TimeLineTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeLineTable.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomView")
        
        TimeLineTable.delegate = self
        TimeLineTable.dataSource = self
        
        FirebaseView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FirebaseView()
    }
    
    
    func FirebaseView(){
        db.collection("tweet").order(by: "date", descending: true).getDocuments { QuerySnapshot, Error in
            if let Error = Error{
                print(Error)
            }else{
                self.documents = QuerySnapshot!.documents
                print(self.documents)
                self.TimeLineTable.reloadData()
            }
            
            
        }
        
    }
    
    func FirebaseReload(){
        let user = Auth.auth().currentUser
        let userId = user?.uid
        db.collection("tweet").order(by: "date", descending: true).getDocuments { [weak self] QuerySnapshot, Error in
            guard let self = self else { return }
            
            if let Error = Error{
                print("Error getting documents: \(Error)")
            } else {
                self.documents = QuerySnapshot!.documents
                print(self.documents)
                self.TimeLineTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
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
        
        cell.TweetText.text = data?["tweet"] as? String
        cell.TweetName.text = data?["name"] as? String
        cell.TweetTime.text = stringDate
        let likeCount = data?["likeCount"] as? String
        cell.TweetLike.text! = likeCount ?? "0"
        
        cell.LikeButton.tag = indexPath.row
        cell.LikeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        return cell
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
            self.updateIncrementLikeCount(postID: postID)
        }
        if self.likeCheck == true{
            self.updateDecrementLikeCount(postID: postID)
        }
        
    }
    
    func LikeCheck(postID:String){
        db.collection("tweet").document(postID).getDocument { DocumentSnapshot, Error in
            if let Error = Error{
                print(Error)
            }else{
                let document = DocumentSnapshot?.data()
                let like = document?["likes"] as? [String]
                self.likeCheck = self.containsString(array: like ?? ["No Array"], searchID: self.uid ?? "No ID")
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
                
                self.updateFirestore(postID: postID, likeCount: likeCount)
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
        self.DeleteID(postID: postID)
        db.collection("tweet").document(postID).getDocument { DocumentSnapshot, Error in
            if let Error = Error{
                print(Error)
            }else{
                let document = DocumentSnapshot?.data()
                let like = document?["likes"] as? [String]
                let likeCount = like?.count ?? 0
                print(likeCount)
                
                self.updateFirestore(postID: postID, likeCount: likeCount)
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
    
class TweetViewController:UIViewController{
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let TimeLineView = TimeLineViewController()
        var name = ""
        
        
        @IBOutlet weak var tweetField: UITextField!
        
        
        
        
        @IBAction func doneButton(_ sender: Any) {
            
            db.collection("user").document(user!.uid).getDocument { DocumentSnapshot, Error in
                if let Error = Error {
                    print(Error)
                }else{
                    if let name = DocumentSnapshot?["Name"] as? String{
                        self.name = name
                        self.tweetSave()
                    }
                }
            }
            
            
            dismiss(animated: true)
            self.view.isHidden = true
            
        }
        
        func tweetSave(){
            db.collection("tweet").document().setData(
                [
                    "tweet": tweetField.text!,
                    "id": user?.uid ?? "Not Login",
                    "name": self.name,
                    "date": Timestamp(date: Date()),
                    "like":0
                ]
                
            )
            print(name)
        }
        
        @IBAction func cancelButton(_ sender: Any) {
            dismiss(animated: true)
            self.view.isHidden = true
        }
        
    
}
