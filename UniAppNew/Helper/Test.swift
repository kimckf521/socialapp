//
//  Test.swift
//  UniAppNew
//
//  Created by Kim on 25/11/20.
//

import Foundation

/*
do {
    try Auth.auth().signOut()
}
catch {
    
}
*/

/*
let uid = UserDefaults.standard.value(forKey: Constants.LocalStorage.userIdkey) as! String
print(uid)
let db = Firestore.firestore()
let userNameA = ["User Name":"abc"]
let passwordA = ["Passwoed":"abc"]
print(userNameA)
print(passwordA)
db.collection("users").document("SsjgxdtDkXUyFIJTPpxicenIkEP2").setData(userNameA, merge: true)
db.collection("users").document("SsjgxdtDkXUyFIJTPpxicenIkEP2").setData(passwordA, merge: true)
*/

/*
let db = Firestore.firestore()

db.collection("users").whereField("Phone Number", in: ["+61444555666"]).getDocuments { (snapshot, error) in
    
    let test = snapshot!.isEmpty
    
    let id = snapshot!.documents
    UserDefaults.standard.setValue("test", forKey: "123")
    let tt = UserDefaults.standard.value(forKey: "123")
    print(tt)
    
    for i in id {
        let k = i.documentID
    }
    if test == true {
        print("Dont have number")
    } else {
        print("Have number")
    }
}
*/

/*
let db = Firestore.firestore()
let pNumber = db.collection("users").whereField("Phone Number", in: ["+61444555666"])

//print(user)
let user = AuthDataResult.value(forKey: "+61444555666")
print(user)
*/

//pNumber.getDocuments { (snapshot, error) in
    
    //let docs = snapshot!.documents
        //print(docs)
    
        
    //for doc in docs {
        //print(doc.exists)
    //}


/*
 
 db.collection("users").whereField("Phone Number", in: [self.PhoneNumber.text]).getDocuments { (snapshot, error) in
     
     let test = snapshot!.isEmpty
     
     
     if test == true {
         print("Dont have number")
         
         PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
             if error == nil {
                 // Do something
                 print(verificationId)
                 
                 guard let verifyId = verificationId else { return }
                 UserDefaults.standard.setValue(verifyId, forKey: "verificationId")
                 
             } else {
                 print("Unable to get Secret Verification Code From firebase", error?.localizedDescription)
             }
         }
         
     } else {
         
         let docs = snapshot!.documents
         for doc in docs {
             print(doc.documentID)
             UserDefaults.standard.set(doc.documentID, forKey: Constants.LocalStorage.userIdkey)
         }
         
         print("Have number")
         UserDefaults.standard.set(self.PhoneNumber.text, forKey: Constants.LocalStorage.userPhonekey)
         let LoginVC = self.storyboard?.instantiateViewController(identifier: Constants.LoginVC)
         guard LoginVC != nil else { return }
         self.view.window?.rootViewController = LoginVC
         self.view.window?.makeKeyAndVisible()
     }
 }
 
 let loginManager = LoginManager()
         loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
             if let error = error {
                 print("Failed to login: \(error.localizedDescription)")
                 return
             }
             
             guard let accessToken = AccessToken.current else {
                 print("Failed to get access token")
                 return
             }
  
             let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
             
             // Perform login by calling Firebase APIs
             Auth.auth().signIn(with: credential, completion: { (user, error) in
                 if let error = error {
                     print("Login error: \(error.localizedDescription)")
                     let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                     let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                     alertController.addAction(okayAction)
                     self.present(alertController, animated: true, completion: nil)
                     return
                 }else {
                 }
             })
         }
 
 */
