//
//  ServiceCollectionViewCell.swift
//  UniAppNew
//
//  Created by Kim on 21/1/21.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    
    var product: Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        serviceImageView.layer.cornerRadius = 20
    }
    
    
    func displayService(product: Product) {
        
        //serviceImageView.layer.cornerRadius = 20
        
        self.serviceImageView.image = nil
        
        self.product = product
        
        let firstImageLink = product.imageLinks.first
        
        serviceTitle.text = product.productName
        
        if firstImageLink == nil {
            return
        }
        
        if let cachedImage = ImageCacheService.getImage(url: firstImageLink) {
            
            self.serviceImageView.image = cachedImage
            
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
                
                if let firstLink = self.product?.imageLinks.first {
                    if url!.absoluteString != firstLink {
                        return
                    }
                }
                
                DispatchQueue.main.async {
                    self.serviceImageView.image = image
                }
            }
            
        }
        dataTask.resume()
    }
    
}
