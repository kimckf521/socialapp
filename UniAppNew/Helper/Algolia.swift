//
//  Algolia.swift
//  UniAppNew
//
//  Created by Kim on 11/1/21.
//

import Foundation
import AlgoliaSearchClient
import Firebase

class Algolia {
    
    static func downloadPosts(_ withIds: [String], completion: @escaping (_ postArray: [Post]) -> Void) {
        
        var postArray: [Post] = []
        var count = 0
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                
                let db = Firestore.firestore().collection("posts")
                db.document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(postArray)
                        return
                    }
                    
                    if snapshot.exists {
                        
                        let createdAtDate:Date = Timestamp.dateValue(snapshot.data()!["createdAt"] as! Timestamp)()
                        let editDate:Date = Timestamp.dateValue(snapshot.data()!["lastEdit"] as! Timestamp)()
                        
                        if snapshot.data()!["imageLinks"] == nil {
                            let n = Post(postId: snapshot.documentID, title: snapshot.data()!["title"] as! String, content: snapshot.data()!["content"] as! String, createdAt: createdAtDate, lastEdit: editDate, imageLinks: [])
                            postArray.append(n)
                        } else {
                            let n = Post(postId: snapshot.documentID, title: snapshot.data()!["title"] as! String, content: snapshot.data()!["content"] as! String, createdAt: createdAtDate, lastEdit: editDate, imageLinks: snapshot.data()!["imageLinks"] as! [String])
                            postArray.append(n)
                        }
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(postArray)
                    }
                }
                
            }
        } else {
            completion(postArray)
        }
        
        
    }
    
    static func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {

        let client = SearchClient(appID: "NFXHRVUMIH", apiKey: "9b5fdb3ac9aa85aeb6ab5b023d0c4e85")
        let index = client.index(withName: "Posts")
        
        var resultIds: [String] = []
        
        var query = Query(searchString)
        
        query.attributesToRetrieve = ["title", "content"]
        
        index.search(query: query) { result in
          switch result {
          case .failure(let error):
            print("Error: \(error)")
            completion(resultIds)
          case .success(let response):
            for id in response.hits {
                resultIds.append(id.objectID.rawValue)
            }
            completion(resultIds)
          }
        }
    }
    
}
