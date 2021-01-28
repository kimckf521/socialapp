//
//  Photo.swift
//  UniAppNew
//
//  Created by Kim on 5/12/20.
//

import Foundation
import Firebase

struct Photo {
    
    var photoId:String?
    var userId:String?
    var username:String?
    var date:String?
    var url:String?
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        // parse the data out
        let data = snapshot.data()
        
        let dphotoId = data["Photo ID"] as? String
        let duserId = data["User ID"] as? String
        let dusername = data["User Name"] as? String
        let ddate = data["createdAt"] as? String
        let durl = data["URL"] as? String
        
        if dphotoId == nil || duserId == nil || dusername == nil || ddate == nil || durl == nil {
            return nil
        }
        
        self.photoId = dphotoId
        self.userId = duserId
        self.username = dusername
        self.date = ddate
        self.url = durl
        
    }
}
