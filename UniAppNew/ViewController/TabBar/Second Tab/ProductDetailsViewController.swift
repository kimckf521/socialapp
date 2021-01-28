//
//  ProductDetailsViewController.swift
//  UniAppNew
//
//  Created by Kim on 4/12/20.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productContent: UITextView!
    @IBOutlet weak var imageUIView: UIView!
    
    var product:Product?
    var marketModel:MarketModel?
    var productImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkImage()
        
        productTitle.text = product?.productName
        productContent.text = product?.productContent
        
        serviceCollectionView.dataSource = self
        serviceCollectionView.delegate = self
        
        downloadPictures()
    }
    
    func checkImage() {
        if product!.imageLinks == [] {
            serviceCollectionView.isHidden = true
        } else {
            serviceCollectionView.isHidden = false
        }
    }
    
    // MARK: - Download Pictures
    
    private func downloadPictures() {
        if product != nil && product?.imageLinks != nil {
            PhotoModel.downloadImages(imageUrls: product!.imageLinks) { (allImages) in
                
                if allImages.count > 0 {
                    
                    DispatchQueue.main.async {
                        self.productImages = allImages as! [UIImage]
                        self.serviceCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count == 0 ? 1 : productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = serviceCollectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceDetailsCollectionViewCell
        
        cell.pageControl.numberOfPages = productImages.count

        cell.pageControl.currentPage = indexPath.row
        
        if productImages.count > 0 {
            cell.setupImage(serviceImage: productImages[indexPath.row])
        }
        
        return cell
    }
    
}
