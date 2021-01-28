//
//  Constants.swift
//  UniAppNew
//
//  Created by Kim on 17/11/20.
//

import Foundation

struct Constants {
    
    static let SignupVC = "SignupVC"
    static let RegistrationVC = "RegistrationVC"
    static let LoginVC = "LoginVC"
    static let TabBarVC = "TabBarVC"
    static let ProfileSegue = "ProfileSegue"
    static let FireStorageLink = "gs://uniappnew.appspot.com"
    
    struct LocalStorage {
        
        static let userIdkey = "storedUserId"
        static let userPhonekey = "storedUserPhone"
        static let userNameKey = "storedUserName"
        static let userEmailKey = "storedEmail"
        static let userInterestKey = "storedInterest"
        
    }
}
