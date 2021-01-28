//
//  ServiceDetailsCollectionViewCell.swift
//  UniAppNew
//
//  Created by Kim on 23/1/21.
//

import UIKit

class ServiceDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    func setupImage(serviceImage: UIImage) {
        imageView.image = serviceImage
        imageView.layer.cornerRadius = 15
    }
    
    
}
