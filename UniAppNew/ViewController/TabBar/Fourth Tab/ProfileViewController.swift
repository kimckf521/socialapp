//
//  ProfileViewController.swift
//  UniAppNew
//
//  Created by Kim on 27/11/20.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var interestText: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var childView: UIView!
    
    
    var appUser:AppUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(appUser?.userEmail!)
        
        nameText.text = appUser?.username!
        emailText.text = appUser?.userEmail!
        interestText.text = appUser?.userInterest!
        
        childView.layer.cornerRadius = 20
        
        
        //stackView.layer.cornerRadius = 20
        /*
        let defaults = UserDefaults.standard
        let uid = defaults.value(forKey: Constants.LocalStorage.userIdkey) as! String
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            if error == nil {
                self.nameText.text = (snapshot!.data()!["User Name"]! as! String)
                self.emailText.text = (snapshot!.data()!["Email"]! as! String)
                self.interestText.text = (snapshot!.data()!["Interest"]! as! String)

            }
            
        }
        */
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let uid = defaults.value(forKey: Constants.LocalStorage.userIdkey) as! String
        
        let db = Firestore.firestore()
        
        let name = ["User Name": nameText.text!]
        let email = ["Email": emailText.text!]
        let interest = ["Interest": interestText.text!]
        let userId = ["User ID": uid]
        let phone = ["Phone Number": ""]
        
        
        db.collection("users").document(uid).setData(name, merge: true)
        db.collection("users").document(uid).setData(email, merge: true)
        db.collection("users").document(uid).setData(interest, merge: true)
        db.collection("users").document(uid).setData(userId, merge: true)
        db.collection("users").document(uid).setData(phone, merge: true)
        
        UserService.testAppUser(UID: Auth.auth().currentUser!.uid) { (Appuser) in
        }
        
    }
    

}


