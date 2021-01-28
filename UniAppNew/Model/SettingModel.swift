//
//  SettingModel.swift
//  UniAppNew
//
//  Created by Kim on 5/12/20.
//

import Foundation
import Firebase

protocol SettingModelProtocol {
    
    func profileRetrieved(appUser:AppUser)
    
}

class SettingModel {
    
    var settingDelegate:SettingModelProtocol?
    
    func getProfile() {
        
        let defaults = UserDefaults.standard
        let uid = defaults.value(forKey: Constants.LocalStorage.userIdkey) as! String
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            var appUser = AppUser()
            
            if error == nil {
                let a = (snapshot!.data()!["userName"]! as! String)
                let b = (snapshot!.data()!["email"]! as! String)
                let c = (snapshot!.data()!["interest"]! as! String)
                let d = (snapshot!.data()!["userId"]! as! String)
                let e = (snapshot!.data()!["phoneNumber"]! as! String)

                let profile = AppUser(userId: d, username: a, userInterest: c, userEmail: b, userPhone: e)
                
                appUser = profile
                
                //print(appUser)
                
                DispatchQueue.main.async {
                    self.settingDelegate?.profileRetrieved(appUser: appUser)
                }
            }
        }
    }
}
