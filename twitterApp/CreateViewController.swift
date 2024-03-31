//
//  CreateViewController.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/09/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class CreateViewController: UIViewController {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var MailField: UITextField!
    @IBOutlet weak var PassField: UITextField!
    
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func CreateButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: MailField.text!, password: PassField.text!) { [self] user, error in
              
            if let error = error{
                print(error)
            }else{
                self.db.collection("user").document(Auth.auth().currentUser!.uid).setData([
                    "Name" : NameField.text!,
                    "Profile" : ""
                ])
                self.performSegue(withIdentifier: "profile", sender: nil)
            }
            
        }
        
    }
    
    
    @IBAction func LoginViewButton(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
