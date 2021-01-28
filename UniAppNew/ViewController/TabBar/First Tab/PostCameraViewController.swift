//
//  PostCameraViewController.swift
//  UniAppNew
//
//  Created by Kim on 5/12/20.
//

import UIKit

class PostCameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let shapeLayer = CAShapeLayer()
//
//        let center = view.center
//        let circularPath = UIBezierPath
        
    }
    
    func savePhoto(image:UIImage) {
        
        PhotoModel.savePhoto(image: image)
        
    }

}
