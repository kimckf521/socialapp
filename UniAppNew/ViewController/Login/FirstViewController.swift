//
//  FirstViewController.swift
//  UniAppNew
//
//  Created by Kim on 17/11/20.
//

// TODO: Change the cloud Firestore Rule

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import Foundation


class FirstViewController: UIViewController {
    
    var numberexist: Bool? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SVProgressHUD.show()
        
        let user = Auth.auth().currentUser?.phoneNumber
        
        
    }
        // Do any additional setup after loading the view.

    @IBAction func signUp(_ sender: Any) {
        
        
        /*
        DispatchQueue.main.async {
            
            let signUpVC = self.storyboard?.instantiateViewController(identifier: Constants.SignupVC)
            guard signUpVC != nil else { return }
            self.view.window?.rootViewController = signUpVC
            self.view.window?.makeKeyAndVisible()
            
        }
        
        SVProgressHUD.dismiss()
        
        */
        
    }
    
    
    
}

