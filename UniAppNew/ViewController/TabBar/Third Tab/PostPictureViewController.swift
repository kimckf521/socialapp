//
//  PostPictureViewController.swift
//  UniAppNew
//
//  Created by Kim on 7/12/20.
//

import UIKit

class PostPictureViewController: UIViewController {

    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                
                self.showImagePickerController(mode: .camera)
                
            }
            
            actionSheet.addAction(cameraButton)
            
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        
            let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                
                self.showImagePickerController(mode: .photoLibrary)
                
            }
            actionSheet.addAction(libraryButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelButton)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(mode: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = mode
        imagePicker.delegate = self
        
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}

extension PostPictureViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get a reference to the selected photo
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        // Check that the selected image isn't nil
        if let selectedImage = selectedImage {
            
            //PhotoModel.savePhoto(image: selectedImage)
            testImageView.image = selectedImage
            
            
            let data = selectedImage.jpegData(compressionQuality: 0.1)
            UserDefaults.standard.setValue(data, forKey: "imageKey")
            
            //print(data)
            /*
            let PhotoVC = self.storyboard?.instantiateViewController(identifier: "PhotoVC")
            guard PhotoVC != nil else { return }
            self.view.window?.rootViewController = PhotoVC
            self.view.window?.makeKeyAndVisible()
            */
            
            //performSegue(withIdentifier: "ToPhotoVC", sender: picker)
        }
        
        dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
            //.popViewController(animated: true)
        
    }
    
}
