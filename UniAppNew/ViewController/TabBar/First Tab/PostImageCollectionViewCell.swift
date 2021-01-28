//
//  PostImageCollectionViewCell.swift
//  UniAppNew
//
//  Created by Kim on 20/1/21.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    func setupImageWith(postImage: UIImage) {
        imageView.image = postImage
        imageView.layer.cornerRadius = 15
    }

}
