//
//  MarketModel.swift
//  UniAppNew
//
//  Created by Kim on 3/12/20.
//

import Foundation
import Firebase

protocol ProductsModelProtocol {
    
    func productsRetrieved(products:[Product])
    func profileRetrieved(appUser:AppUser)
    
}

class MarketModel {
    
    var delegate:ProductsModelProtocol?
    
    var listener:ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    
    func getProduct() {
        
        let db = Firestore.firestore()
        
        self.listener = db.collection("products").order(by: "lastEdit", descending: true).addSnapshotListener { (snapshot, error) in
        //db.collection("products").getDocuments { (snapshot, error) in
    
            
            if error == nil && snapshot != nil {
                
                var products = [Product]()
                
                for doc in snapshot!.documents {
                    
                    let createdAtDate:Date = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    let editDate:Date = Timestamp.dateValue(doc["lastEdit"] as! Timestamp)()
                    
                    if doc["imageLinks"] == nil {
                        
                        let n = Product(userId: doc["userId"] as! String, userName: doc["username"] as! String, productId: doc["postId"] as! String, productName: doc["title"] as! String, productContent: doc["content"] as! String, imageLinks: [], createdAt: createdAtDate, lastEdit: editDate)

                        products.append(n)
                        
                    } else {
                        
                        let n = Product(userId: doc["userId"] as! String, userName: doc["username"] as! String, productId: doc["postId"] as! String, productName: doc["title"] as! String, productContent: doc["content"] as! String, imageLinks: (doc["imageLinks"] as! [String]), createdAt: createdAtDate, lastEdit: editDate)

                        products.append(n)
                    }
                }
                
                DispatchQueue.main.async {
                    self.delegate?.productsRetrieved(products: products)
                }
            }
        }
    }
    
    func saveProduct(_ n:Product) {
        
        let db = Firestore.firestore()
        
        db.collection("products").document(n.productId).setData(productToDict(n))
        
    }
    
    func productToDict(_ n:Product) -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["userId"] = n.userId
        dict["username"] = n.userName
        dict["postId"] = n.productId
        dict["title"] = n.productName
        dict["content"] = n.productContent
        dict["imageLinks"] = n.imageLinks
        dict["createdAt"] = n.createdAt
        dict["lastEdit"] = n.lastEdit
        
        return dict
    }
    
    func getProfile() {
        
        let defaults = UserDefaults.standard
        let uid = defaults.value(forKey: Constants.LocalStorage.userIdkey) as! String
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            var appUser = AppUser()
            
            if error == nil {
                
                let a = (snapshot!.data()!["email"]! as! String)
                let b = (snapshot!.data()!["interest"]! as! String)
                let c = (snapshot!.data()!["userName"]! as! String)
                let d = (snapshot!.data()!["userId"]! as! String)
                let e = (snapshot!.data()!["phoneNumber"]! as! String)

                let n = AppUser(userId: d, username: c, userInterest: b, userEmail: a, userPhone: e)
                
                appUser = n
                
                DispatchQueue.main.async {
                    self.delegate?.profileRetrieved(appUser: appUser)
                }
                
                //print(appUser.username!)
            }
            
        }
        
    }
    
    func test() {
        
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("phoneNumber", isEqualTo: "+61449979687").getDocuments { (snapshot, error) in
            
            let test = snapshot!.isEmpty
            
            print(test)
        }
        
    }
    
}
