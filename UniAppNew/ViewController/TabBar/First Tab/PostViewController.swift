//
//  PostViewController.swift
//  UniAppNew
//
//  Created by Kim on 27/11/20.
//

import UIKit
import Firebase
import Gallery
import JGProgressHUD


class PostViewController: UIViewController {


    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var Content: UITextView!
    
    var post:Post?
    var postsModel = PostsModel()
    var postImages: [UIImage?] = []
    var gallery: GalleryController!
    let hub = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func photoButton(_ sender: Any) {
        postImages = []
        showImageGallery()
    }
    
    @IBAction func postButton(_ sender: Any) {
        dismissKeayboard()
        
        if fieldsAreCompleted() {
            savetoFirebase()
            goToPostTableList()
        } else {
            self.hub.textLabel.text = "All fields are required"
            self.hub.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hub.show(in: self.view)
            self.hub.dismiss(afterDelay: 2)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeayboard()
    }
    
    
    // MARK: - Helper functions
    
    private func fieldsAreCompleted() -> Bool {
        return (titleText.text != "" && Content.text != "")
    }
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    
    private func goToPostTableList() {
        self.performSegue(withIdentifier: "gotoTapOne", sender: self)
    }
    
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
        
        let postId = UUID().uuidString
        
        var n = Post(postId: postId, title: titleText.text!, content: Content.text!, createdAt: Date(), lastEdit: Date(), imageLinks: [])
        
        //postsModel.savePost(n)
        
        if postImages.count > 0 {
            
            PhotoModel.uploadImages(images: postImages, postId: postId) { (imageLinkArray) in
                n.imageLinks = imageLinkArray
                self.postsModel.savePost(n)
            }
            
        } else {
            postsModel.savePost(n)
            popTheView()
        }
        
    }
    
}


extension PostViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.postImages = resolvedImages
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
