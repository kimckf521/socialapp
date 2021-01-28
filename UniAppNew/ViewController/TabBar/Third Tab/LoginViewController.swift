//
//  LoginViewController.swift
//  UniAppNew
//
//  Created by Kim on 11/11/20.
//

import UIKit


class LoginViewController: UIViewController{
    
    @IBOutlet weak var tImageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imgData = UserDefaults.standard.object(forKey: "imageKey") {
            let retrieveImg = UIImage(data: imgData as! Data)
            tImageV.image = retrieveImg
        }
        
        
    }
    
 

}
    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//    }

