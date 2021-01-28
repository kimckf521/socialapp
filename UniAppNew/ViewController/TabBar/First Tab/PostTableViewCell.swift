//
//  PostTableViewCell.swift
//  UniAppNew
//
//  Created by Kim on 17/1/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        postImage.layer.cornerRadius = 10
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.y += 10
            frame.origin.x += 10
            frame.size.height -= 15
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayPost(post: Post) {
        
        self.imageView?.image = nil
        
        self.post = post
        
        let firstImageLink = post.imageLinks.first
        
        postTitle.text = post.title
        
        if firstImageLink == nil {
            return
        }
        
        if let cachedImage = ImageCacheService.getImage(url: firstImageLink) {
            
            self.postImage.image = cachedImage
            
            return
            
        }
        
        let url = URL(string: firstImageLink!)
        
        if url == nil {
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let image = UIImage(data: data!)
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)
                
                if let firstLink = self.post?.imageLinks.first {
                    if url!.absoluteString != firstLink {
                        return
                    }
                }
                
                DispatchQueue.main.async {
                    self.postImage.image = image
                }
            }
            
        }
        dataTask.resume()
    }

}
