//
//  PostProductsViewController.swift
//  UniAppNew
//
//  Created by Kim on 3/12/20.
//

import UIKit
import Gallery
import JGProgressHUD
import Firebase

class PostProductsViewController: UIViewController {
    
    @IBOutlet weak var productTitle: UITextField!
    @IBOutlet weak var productContent: UITextView!
    
    var product:Product?
    var marketModel = MarketModel()
    var productImages: [UIImage?] = []
    var gallery: GalleryController!
    let hub = JGProgressHUD(style: .dark)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func camera(_ sender: Any) {
        productImages = []
        showImageGallery()
    }
    
    
    @IBAction func confirmButton(_ sender: Any) {
        
        dismissKeayboard()
        
        if fieldsAreCompleted() {
            savetoFirebase()
            //goToPostTableList()
            popTheView()
        } else {
            self.hub.textLabel.text = "All fields are required"
            self.hub.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hub.show(in: self.view)
            self.hub.dismiss(afterDelay: 2)
        }
        
//        let producttitle = productTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        if producttitle == nil || producttitle == "" || producttitle == "Title"{
//            return
//        }
//
//        let content = productContent.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        if content == nil || content == "" || content == "Content"{
//            return
//        }
//
//        let defaults = UserDefaults.standard
//
//        let uid = defaults.value(forKey: Constants.LocalStorage.userIdkey) as! String
//
//        let username = LocalStorageService.loadUser()?.username
//
//        if let usernameD = username {
//
//            let n = Product(userId: uid, userName: usernameD, productId: UUID().uuidString, productName: producttitle!, productContent: content!, imageLinks: [], createdAt: Date(), lastEdit: Date())
//
//            self.product = n
//
//            self.marketModel?.saveProduct(self.product!)
//        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeayboard()
    }
    
    // MARK: - Helper functions
    
    private func fieldsAreCompleted() -> Bool {
        return (productTitle.text != "" && productContent.text != "")
    }
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    
//    private func goToPostTableList() {
//        self.performSegue(withIdentifier: "gotoTapOne", sender: self)
//    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Image
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
    // MARK: - Save Post
    private func savetoFirebase() {
        
        let userId = Auth.auth().currentUser?.uid
        let username = LocalStorageService.loadUser()?.username
        let productId = UUID().uuidString
        let producttitle = productTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = productContent.text
        
        var n = Product(userId: userId!, userName: username!, productId: productId, productName: producttitle!, productContent: content!, imageLinks: [], createdAt: Date(), lastEdit: Date())
        
        //postsModel.savePost(n)
        
        if productImages.count > 0 {
            
            PhotoModel.uploadImages(images: productImages, postId: productId) { (imageLinkArray) in
                n.imageLinks = imageLinkArray
                DispatchQueue.main.async {
                    self.marketModel.saveProduct(n)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                self.marketModel.saveProduct(n)
            }
        }
        
    }
    
    
}


extension PostProductsViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.productImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
