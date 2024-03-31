//
//  ViewController.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/09/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var MailField: UITextField!
    
    @IBOutlet weak var PassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Auth.auth().currentUser?.uid as Any)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(Auth.auth().currentUser?.uid as Any)
        if Auth.auth().currentUser?.uid != nil{
            performSegue(withIdentifier: "profile", sender: self)
        }
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: MailField.text!, password: PassField.text!) { result, error in
            if let error = error{
                print(error)
            }else{
            print(error ?? "No Error")
            print(Auth.auth().currentUser?.uid as Any)
            self.performSegue(withIdentifier: "profile", sender: self)
            }
        }
    }
    
    @IBAction func CreateViewButton(_ sender: Any) {
        
        performSegue(withIdentifier: "create", sender: self)
        
       
    }
    

}

