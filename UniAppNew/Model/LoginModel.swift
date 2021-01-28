//
//  LoginModel.swift
//  UniAppNew
//
//  Created by Kim on 5/12/20.
//

import Foundation
import Firebase

class LoginModel {
    
    func saveRegistration(n:AppUser) {
        
        let db = Firestore.firestore()
        
        DispatchQueue.main.async {
            db.collection("users").document(n.userId!).setData(self.registrationToDict(n))
        }
        
    }
    
    private func registrationToDict(_ n:AppUser) -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["userId"] = n.userId
        dict["userName"] = n.username
        dict["email"] = n.userEmail
        dict["phoneNumber"] = n.userPhone
        dict["interest"] = n.userInterest
        
        return dict
    }
    
}
