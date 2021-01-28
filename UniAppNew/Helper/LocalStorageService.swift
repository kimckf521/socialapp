//
//  LocalStorageService.swift
//  UniAppNew
//
//  Created by Kim on 22/11/20.
//

import Foundation
import Firebase

class LocalStorageService {
    
    static func saveUserPhone(userID:String?, phoneNumber:String?) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(userID, forKey: Constants.LocalStorage.userIdkey)
        defaults.set(phoneNumber, forKey: Constants.LocalStorage.userPhonekey)
        
    }
    
    static func loadUser() -> AppUser? {
        
        let defaults = UserDefaults.standard
        
        let userId = defaults.value(forKey: Constants.LocalStorage.userIdkey) as? String
        let userInterest = defaults.value(forKey: Constants.LocalStorage.userInterestKey) as? String
        let userPhone = defaults.value(forKey: Constants.LocalStorage.userPhonekey) as? String
        let userEmail = defaults.value(forKey: Constants.LocalStorage.userEmailKey) as? String
        let userName = defaults.value(forKey: Constants.LocalStorage.userNameKey) as? String
        
        
        if userId != nil {
            return AppUser(userId: userId, username: userName, userInterest: userInterest, userEmail: userEmail, userPhone: userPhone)
        }
        else {
            return nil
        }
        
    }
    
    static func clearUser() {
        
        let defaults = UserDefaults.standard
        let userId = defaults.set(nil, forKey: Constants.LocalStorage.userIdkey)
        
    }
    
    static func checkUserv1(completion: @escaping (Bool)->()) {
        
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (snapshot, error) in
            
            if error == nil {
                
                let a = (snapshot!.data()!["email"] as? String)
                let b = (snapshot!.data()!["interest"] as? String)
                let c = (snapshot!.data()!["userName"] as? String)
                let d = (snapshot!.data()!["userId"] as? String)
                let e = (snapshot!.data()!["phoneNumber"] as? String)
        
                if a == nil || b == nil || c == nil || d == nil || e == nil {
                    completion(false)
                }
            }
        }
    }
    
    static func checkUserv2() -> AppUser? {
    
        let defaults = UserDefaults.standard
        
        let userId = defaults.value(forKey: Constants.LocalStorage.userIdkey) as? String
        let userInterest = defaults.value(forKey: Constants.LocalStorage.userInterestKey) as? String
        let userPhone = defaults.value(forKey: Constants.LocalStorage.userPhonekey) as? String
        let userEmail = defaults.value(forKey: Constants.LocalStorage.userEmailKey) as? String
        let userName = defaults.value(forKey: Constants.LocalStorage.userNameKey) as? String
        
        
        if userId != nil && userInterest != nil && userPhone != nil && userEmail != nil && userName != nil {
            return AppUser(userId: userId, username: userName, userInterest: userInterest, userEmail: userEmail, userPhone: userPhone)
        }
        else {
            return nil
        }
    
    }
    
    
}
