//
//  SettingViewController.swift
//  UniAppNew
//
//  Created by Kim on 18/11/20.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    private var settingModel = SettingModel()
    private var appUser = AppUser()
    
    @IBOutlet weak var profilePic: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        settingModel.settingDelegate = self
        settingModel.getProfile()
        // Do any additional setup after loading the view.
        self.appUser = LocalStorageService.loadUser()!
//        print("AppUser")
//        print(appUser)
        
        profilePicture()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ProfileVC") {
            
            let profileVC = segue.destination as! ProfileViewController
            profileVC.appUser = self.appUser
        }
        
    }
    
    func profilePicture() {
        
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
        let link = "https://firebasestorage.googleapis.com/v0/b/uniappnew.appspot.com/o/images%2FeHToH5GrEDNSdOukFQaZnH6NrmA2%2FB8FB8070-02D8-4A63-8752-909E581CEBBF%2Fimage0.jpg?alt=media&token=7a0d783c-ec8d-4c1e-a235-3014aa3fb9f4"
        
        let url = URL(string: link)
        
        if url == nil {
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let image = UIImage(data: data!)
                
                
                DispatchQueue.main.async {
                    self.profilePic.image = image
                }
            }
            
        }
        dataTask.resume()
        
    }
    
    @IBAction func goToSetting(_ sender: UIStoryboardSegue) {
        
    }

    
    @IBAction func profileButton(_ sender: Any) {
    }
    
    
    
    @IBAction func signOutButton(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
          try firebaseAuth.signOut()
            
            print(Auth.auth().currentUser?.phoneNumber ?? "Not working")
            print(Auth.auth().currentUser?.uid ?? "Not working")
            
            LocalStorageService.clearUser()
            
            let LoginVC = self.storyboard?.instantiateViewController(identifier: Constants.LoginVC)
            guard LoginVC != nil else { return }
            self.view.window?.rootViewController = LoginVC
            self.view.window?.makeKeyAndVisible()
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}

extension SettingViewController: SettingModelProtocol {
    
    func profileRetrieved(appUser: AppUser) {
        
        self.appUser = appUser
        
    }
    
}
