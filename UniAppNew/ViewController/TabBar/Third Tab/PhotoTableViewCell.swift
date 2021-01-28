//
//  PhotoTableViewCell.swift
//  UniAppNew
//
//  Created by Kim on 7/12/20.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var photo:Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayPhoto(photo:Photo) {
        
        // Reset the image
        self.photoImageView.image = nil
        
        // Set photo property
        self.photo = photo
        
        usernameLabel.text = photo.username
        dateLabel.text = photo.date
        
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
    }

}
