//
//  PhotoDetailsViewController.swift
//  UniAppNew
//
//  Created by Kim on 8/12/20.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    
    var photos:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //nameText.text = photos!.username
        //dateText.text = photos!.date
        displayPhoto(photo: photos!)

    }
    
    func displayPhoto(photo:Photo) {
        
        nameText.text = photo.username
        dateText.text = photo.date
        
        
        if photo.url == nil {
            return
        }
        
        // Check if the image is in our image cache, if it is, use it
        if let cachedImage = ImageCacheService.getImage(url: photo.url!) {
            
            // Use the cached image
            self.photoView.image = cachedImage
            
            return
        }
        
        let url = URL(string: photo.url!)
        
        if url == nil {
            return
        }
        
        
        let session = URLSession.shared
        
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                
                // Set the image view
                let image = UIImage(data: data!)
                
                // Store the image data in cache
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)
                
                
                // Check that the image data we downloaded matches the photo this cell is currently supposed to display
                
                
                if url!.absoluteString != self.photos?.url! {
                    
                    // The url we downloaded doesn't match the url this cell is currently displaying
                    return
                }
                
                DispatchQueue.main.async {
                    self.photoView.image = image
                }
            }
            
        }
        dataTask.resume()

    }
}

/*
 func displayPhoto(photo:Photo) {
     
     nameText.text = photo.username
     dateText.text = photo.date
     
     /*
     if photo.url == nil {
         return
     }
     
     // Check if the image is in our image cache, if it is, use it
     if let cachedImage = ImageCacheService.getImage(url: photo.url!) {
         
         // Use the cached image
         self.photoImageView.image = cachedImage
         
         return
     }
     
     let url = URL(string: photo.url!)
     
     if url == nil {
         return
     }
     
     let session = URLSession.shared
     
     let dataTask = session.dataTask(with: url!) { (data, response, error) in
         
         if error == nil && data != nil {
             
             print("data")
             print(data)
             
             // Set the image view
             let image = UIImage(data: data!)
             
             // Store the image data in cache
             ImageCacheService.saveImage(url: url!.absoluteString, image: image)
             
             
             // Check that the image data we downloaded matches the photo this cell is currently supposed to display
             
             if url!.absoluteString != self.photo?.url! {
                 
                 // The url we downloaded doesn't match the url this cell is currently displaying
                 return
             }
             
             DispatchQueue.main.async {
                 self.photoImageView.image = image
             }
         }
         
     }
     dataTask.resume()
 */
 }
 */
