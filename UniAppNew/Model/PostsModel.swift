//
//  PostsModel.swift
//  UniAppNew
//
//  Created by Kim on 27/11/20.
//

import Foundation
import Firebase

protocol PostsModelProtocol {
    
    func postsRetrieved(posts:[Post])
    func profileRetrieved(appUser:AppUser)
    
}

protocol CommentsProtocol {
    func commentsRetrieved(comments:[Comment])
}

class PostsModel {
    
    var delegate:PostsModelProtocol?
    var commentDelegate:CommentsProtocol?
    
    var listener:ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func getPost() {
        
        let db = Firestore.firestore()
        
        self.listener = db.collection("posts").order(by: "lastEdit", descending: true).addSnapshotListener { (snapshot, error) in
        //db.collection("posts").getDocuments { (snapshot, error) in
    
            
            if error == nil && snapshot != nil {
                
                var posts = [Post]()
                
                for doc in snapshot!.documents {
                    
                    let createdAtDate:Date = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    let editDate:Date = Timestamp.dateValue(doc["lastEdit"] as! Timestamp)()
                    
                    if doc["imageLinks"] == nil {
                        let n = Post(postId: doc["postId"] as! String, title: doc["title"] as! String, content: doc["content"] as! String, createdAt: createdAtDate, lastEdit: editDate, imageLinks: [])
                        
                        posts.append(n)
                        
                    } else {
                        
                        let n = Post(postId: doc["postId"] as! String, title: doc["title"] as! String, content: doc["content"] as! String, createdAt: createdAtDate, lastEdit: editDate, imageLinks: (doc["imageLinks"] as! [String]))
                        
                        posts.append(n)
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.delegate?.postsRetrieved(posts: posts)
                }
            }
        }
    }
    
    func savePost(_ n:Post) {
        
        let db = Firestore.firestore()
        print(n)
        db.collection("posts").document(n.postId).setData(postToDict(n))
        
    }
    
    func saveComment(_ n:Comment, _ m:Post) {
        
        let db = Firestore.firestore()
        
        db.collection("posts").document(m.postId).collection("comments").document(n.commentId).setData(commentToDict(n))
        db.collection("posts").document(m.postId).setData(["lastEdit":n.createdAt], merge: true)
        
    }
    
    func postToDict(_ n:Post) -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["postId"] = n.postId
        dict["title"] = n.title
        dict["content"] = n.content
        dict["createdAt"] = n.createdAt
        dict["lastEdit"] = n.lastEdit
        dict["imageLinks"] = n.imageLinks
        
        return dict
    }
    
    func replyPost(_ n:Comment, _ m:Post) {
    }
    
    
    func commentToDict(_ n:Comment) -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["commentId"] = n.commentId
        dict["userName"] = n.username
        dict["content"] = n.content
        dict["createdAt"] = n.createdAt
        
        return dict
    }
    
    func getProfile() {
        
        let defaults = UserDefaults.standard
        let uid = defaults.value(forKey: Constants.LocalStorage.userIdkey) as! String
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            var appUser = AppUser()
            
            if error == nil {
                
                let dict = snapshot?.data() as! [String : String]
                
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
    
    //*
    func getComment(_ n:Post) {
        
        let db = Firestore.firestore()
        
        db.collection("posts").document(n.postId).collection("comments").order(by: "createdAt", descending: true).addSnapshotListener { (snapshot, error) in
        //db.collection("posts").document("").collection("comments").order(by: "createdAt", descending: true).getDocuments { (snapshot, error) in
    
            
            if error == nil && snapshot != nil {
                
                var comments = [Comment]()
                
                for doc in snapshot!.documents {
                    
                    let createdAtDate:Date = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    
                    let n = Comment(username: doc["userName"] as! String, commentId: doc["commentId"] as! String, content: doc["content"] as! String, createdAt: createdAtDate)
                        //Post(postId: doc["Post ID"] as! String, title: doc["Title"]as! String, content: doc["Content"]as! String, createdAt: createdAtDate, lastEdit: editDate)

                    //print(n)
                    
                    comments.append(n)
                    
                }
                
                DispatchQueue.main.async {
                    self.commentDelegate?.commentsRetrieved(comments: comments)
                }
            }
        }
    }
    
    
}
