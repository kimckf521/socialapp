//
//  UserService.swift
//  UniAppNew
//
//  Created by Kim on 17/11/20.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func retrieveProfile(UID:String) {
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Check for a profile, given the user id
        db.collection("users").document(UID).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                // Something wrong happened
                return
            }
            
            if let profile = snapshot!.data() {
                // Profile was found, create a new photo user
                var u = AppUser()
                u.userId = snapshot!.documentID
                u.username = profile["username"] as? String
                
                // Return the user
            }
            else {
                // Could not get profile, no profile
                // Return nil
            }
        }
    }
    
    static func testAppUser(UID:String, completion: @escaping (AppUser?)->()){
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Check for a profile, given the user id
        db.collection("users").document(UID).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                // Something wrong happened
                return
            }
            
            if let profile = snapshot!.data() {
                // Profile was found, create a new photo user
                var u = AppUser()
                u.userId = snapshot!.documentID
                u.username = profile["userName"] as? String
                u.userEmail = profile["email"] as? String
                u.userInterest = profile["interest"] as? String
                u.userPhone = profile["phoneNumber"] as? String
                
                let defaults = UserDefaults.standard
                defaults.set(u.username, forKey: Constants.LocalStorage.userNameKey)
                defaults.set(u.userEmail, forKey: Constants.LocalStorage.userEmailKey)
                defaults.set(u.userInterest, forKey: Constants.LocalStorage.userInterestKey)
                defaults.set(u.userPhone, forKey: Constants.LocalStorage.userPhonekey)
                
                // Return the user
                completion(u)
            }
            else {
                // Could not get profile, no profile
                // Return nil
                completion(nil)
            }
        }
        
        
    }
    
    
}


// MARK: - Fill Database

//db.whereField("User Name", isNotEqualTo: "").getDocuments { (snapshot, error) in
//
//    let dbs = Firestore.firestore().collection("products")
//
//    if snapshot != nil && error == nil {
//        for doc in snapshot!.documents {
//            print(doc.documentID)
//            dbs.document("\(doc.documentID)").setData(["content":""], merge: true)
//            dbs.document("\(doc.documentID)").setData(["postId":""], merge: true)
//            dbs.document("\(doc.documentID)").setData(["title":""], merge: true)
//            dbs.document("\(doc.documentID)").setData(["userId":""], merge: true)
//            dbs.document("\(doc.documentID)").setData(["username":""], merge: true)
//        }
//    }
//
//}
