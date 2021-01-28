//
//  PhoneAuthViewController.swift
//  UniAppNew
//
//  Created by Kim on 14/11/20.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Firebase
import SVProgressHUD

class PhoneAuthViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var PhoneNumber: UITextField!
    
    @IBOutlet weak var Otp: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func phoneSignIn(_ sender: Any) {
        
        guard let phoneNumber = PhoneNumber.text else { return }
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if error == nil {
                // Do something
                print(verificationId!)
                
                guard let verifyId = verificationId else { return }
                UserDefaults.standard.setValue(verifyId, forKey: "verificationId")
                
            } else {
                print("Unable to get Secret Verification Code From firebase", error!.localizedDescription)
            }
        }
        
    }
    
    @IBAction func verifyOtp(_ sender: Any) {
        
        guard let otpCode = Otp.text else { return }
        
        guard let verificationId = UserDefaults.standard.string(forKey: "verificationId") else { return }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otpCode)
    
        Auth.auth().signIn(with: credential) { (success, error) in
            
            if error == nil {
                
                self.stackView.alpha = 0
                
                SVProgressHUD.setDefaultStyle(.dark)
                SVProgressHUD.show(withStatus: "Testing")
                
                let db = Firestore.firestore()
                
                db.collection("users").whereField("phoneNumber", isEqualTo: self.PhoneNumber.text!).getDocuments { (snapshot, error) in
                    
                    let test = snapshot!.isEmpty
                    
                    print(test)
                    
                    if test == true {
                        let uid = Auth.auth().currentUser!.uid
                        UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
                        
                        print("Registration")
                        SVProgressHUD.dismiss()
                        
                        let RegistrationVC = self.storyboard?.instantiateViewController(identifier: Constants.RegistrationVC)
                        guard RegistrationVC != nil else { return }
                        self.view.window?.rootViewController = RegistrationVC
                        self.view.window?.makeKeyAndVisible()
                        
                    }
                    
                    else {
                        
                        print("User Signed in")
                        //print(Auth.auth().currentUser!.phoneNumber!)
                        //print(Auth.auth().currentUser!.uid)
                        
                        /*
                        var user = AppUser()
                        
                        user.userId = Auth.auth().currentUser!.uid
                        user.userPhone = Auth.auth().currentUser!.phoneNumber!
                        
                        let phoneNumber = ["Phone Number":Auth.auth().currentUser!.phoneNumber]
                        
                        if let uid = Auth.auth().currentUser?.uid {
                            db.collection("users").document(uid).setData(phoneNumber, merge: true)
                        }
                        */
                        
                        SVProgressHUD.dismiss()
                        
                        let uid = Auth.auth().currentUser!.uid
                        UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
                        
                        
                        let TabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.TabBarVC)
                        guard TabBarVC != nil else { return }
                        self.view.window?.rootViewController = TabBarVC
                        self.view.window?.makeKeyAndVisible()
                        
                    }
                    
                }
                
                
            } else {
                print("Something went wrong due to \(error!.localizedDescription)")
            }
        }
        
    }
    
    
}
