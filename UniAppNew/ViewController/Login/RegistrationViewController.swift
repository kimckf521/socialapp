//
//  RegistrationViewController.swift
//  UniAppNew
//
//  Created by Kim on 20/11/20.
//

import UIKit
import Firebase

class RegistrationViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var interestText: UITextField!
    
    private var loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailText.text = Auth.auth().currentUser?.email
        phoneNumberText.text = Auth.auth().currentUser?.phoneNumber
        
        userNameText.delegate = self
        emailText.delegate = self
        phoneNumberText.delegate = self
        interestText.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss keyboard when press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameText.resignFirstResponder()
        emailText.resignFirstResponder()
        phoneNumberText.resignFirstResponder()
        interestText.resignFirstResponder()
        
        return true
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        
        let username = userNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if username == nil || username == "" {
            return
        }
        
        let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == nil || email == "" {
            return
        }
        
        let phone = phoneNumberText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if phone == nil || phone == "" {
            return
        }
        
        let interest = interestText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if interest == nil || interest == "" {
            return
        }
        
        let uid = Auth.auth().currentUser!.uid
        UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
        
        let n = AppUser(userId: Auth.auth().currentUser?.uid, username: username, userInterest: interest, userEmail: email, userPhone: phone)
        
        loginModel.saveRegistration(n: n)
        
        // User defailt saving
        UserService.testAppUser(UID: Auth.auth().currentUser!.uid) { (Appuser) in
        }
        
        let TabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.TabBarVC)
        guard TabBarVC != nil else { return }
        self.view.window?.rootViewController = TabBarVC
        self.view.window?.makeKeyAndVisible()
    }
    

    /*
    @IBAction func confirmButton(_ sender: Any) {
        let uid = UserDefaults.standard.value(forKey: Constants.LocalStorage.userIdkey) as! String
        print(uid)
        let db = Firestore.firestore()
        let userNameA = ["User Name":userName.text!]
        let passwordA = ["Passwoed":password.text!]
        print(userNameA)
        print(passwordA)
        db.collection("users").document(uid).setData(userNameA, merge: true)
        db.collection("users").document(uid).setData(passwordA, merge: true)
    }
    */

    
}

