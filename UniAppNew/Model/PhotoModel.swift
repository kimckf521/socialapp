//
//  PhotoModel.swift
//  UniAppNew
//
//  Created by Kim on 5/12/20.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import SystemConfiguration

class PhotoModel {
    
    
    
    static func retrievePhotos(completion: @escaping ([Photo]) -> Void) {
        
        let db = Firestore.firestore()
        
    db.collection("photos").order(by: "createdAt", descending: true).addSnapshotListener { (snapshot, error) in
        //db.collection("photos").getDocuments { (snapshot, error) in
            
            if error != nil {
                
                return
            }
            
            let documents = snapshot?.documents
            
            if let documents = documents {
                
                var photoArray = [Photo]()
                
                for doc in documents {
                    
                    let p = Photo(snapshot: doc)

                    if p != nil {

                        photoArray.insert(p!, at: 0)
                    }
                }
                
                completion(photoArray)
            }
            
        }
        
        
    }
    
    static func savePhoto(image:UIImage) {
        
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            return
        }
        
        // Create a photo ID
        let photoId = UUID().uuidString
        
        // Get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
        
        // Create a firebase storage path/referencer
        let ref = Storage.storage().reference().child("images/\(userId)/\(photoId).jpg")
        
        // Upload the data
        ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            // Check if upload was successful
            if error == nil {
                
                // Upon successful upload, create the database entry
                self.createDatabaseEntry(ref: ref)
            }
        }
    }
 
    private static func createDatabaseEntry(ref:StorageReference) {
        
        // Download url
        ref.downloadURL { (url, error) in
            
            if error == nil {
                
                // Photo id
                let photoId = ref.fullPath
                
                // TODO: Set LocalStorage loadUser function
                // User id
                let appUser = LocalStorageService.loadUser()
                
                let userId = appUser?.userId
                
                // Username
                let userName = appUser?.username
                
                // Date
                let df = DateFormatter()
                df.dateStyle = .full
                let date = df.string(from: Date())
                
                let metadata = ["Photo ID":photoId, "User ID":userId!, "User Name":userName!, "createdAt":date, "URL":url!.absoluteString] as [String : Any]
                
                // Save the metadata to the firestore database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    
                    if error == nil {
                        
                        
                    }
                }
            }
        }
    }
    
    static func uploadImages(images: [UIImage?], postId: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
        
        // TODO: Check for off link mode later (Reachabilty)
        var uploadedImageCount = 0
        var imageLinkArray: [String] = []
        let userId = Auth.auth().currentUser!.uid
        var photoId = 0
        
        for image in images {
            let fileName = "images/" + "\(userId)/" + postId + "/" + "image\(photoId)" + ".jpg"
            let imageData = image?.jpegData(compressionQuality: 0.1)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    
                    uploadedImageCount += 1
                    
                    if uploadedImageCount == images.count {
                        completion(imageLinkArray)
                    }
                }
                
            }
            photoId += 1
        }
        
    }
    
    static func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink: String?) -> Void) {
        
        var task: StorageUploadTask!
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference(forURL: Constants.FireStorageLink).child(fileName)
        
        task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("Error uploading image", error!.localizedDescription)
                completion(nil)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
        
    }
    
    static func downloadImages(imageUrls: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
        
        var imageArray: [UIImage] = []
        
        var downloadCounter = 0
        
        for link in imageUrls {
            
            let url = NSURL(string: link)
            
            let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
            
            downloadQueue.async {
                
                downloadCounter += 1
                
                let data = NSData(contentsOf: url! as URL)
                
                if data != nil {
                    imageArray.append(UIImage(data: data! as Data)!)
                    
                    if downloadCounter == imageArray.count {
                        
                        DispatchQueue.main.async {
                            completion(imageArray)
                        }
                    }
                } else {
                    print("couldnt dowload image")
                    completion(imageArray)
                }
            }
        }
    }
    
}
