//
//  MarketPlaceViewController.swift
//  UniAppNew
//
//  Created by Kim on 2/12/20.
//

import UIKit

class MarketPlaceViewController: UIViewController {

    
    @IBOutlet weak var productsCV: UICollectionView!

    private var marketModel = MarketModel()
    private var products = [Product]()
    private var appUser = AppUser()
    
    let p = LocalStorageService.loadUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsCV.dataSource = self
        productsCV.delegate = self
        
        marketModel.delegate = self
        //marketModel.getProfile()
        marketModel.getProduct()
        //marketModel.test()
        
        //print(p?.userEmail)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "postProductsVC") {
            
            let postProductsVC = segue.destination as! PostProductsViewController
            postProductsVC.marketModel = self.marketModel
            //postProductsVC.appUser = self.appUser
        }
        
        else if (segue.identifier == "productDetailsVC") {
            
            let postProductsVC = segue.destination as! ProductDetailsViewController
            
            if productsCV.indexPathsForSelectedItems != nil {
                
                //print("working")
                postProductsVC.product = products[productsCV.indexPathsForSelectedItems!.first!.row]
                //postDetailsVC.post = posts[tableView.indexPathForSelectedRow!.row]
                //tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                
            }
        }
        
    }
    
    @IBAction func goToMarketPlace(_ sender: UIStoryboardSegue) {
    }
    
}

extension MarketPlaceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if products[indexPath.row].imageLinks != [nil] && products[indexPath.row].imageLinks.count > 0 {
            let cell = productsCV.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ServiceCollectionViewCell
            
            let products = self.products[indexPath.row]
            
            cell?.displayService(product: products)
            
            return cell!
            
        } else {
            
            let cell = productsCV.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath)
            
            //cell.layer.cornerRadius = 15
            
            let titleLabel = cell.viewWithTag(31) as? UILabel
            
            let imageView = cell.viewWithTag(2) as? UIImageView
            
            titleLabel?.text = products[indexPath.row].productName
            
            imageView?.image = UIImage(named: "emptyData")
            
            return cell
        }
    }
}

extension MarketPlaceViewController: ProductsModelProtocol {
    
    func productsRetrieved(products: [Product]) {
        
        self.products = products
        productsCV.reloadData()
        //print(products)
        
        
    }
    
    func profileRetrieved(appUser: AppUser) {
        
        self.appUser = appUser
        //print(appUser.username)
        
    }
    
    
    
}
