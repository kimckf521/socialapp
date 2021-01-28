//
//  FirebaseCollectionReference.swift
//  UniAppNew
//
//  Created by Kim on 14/1/21.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case users
    case posts
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}
