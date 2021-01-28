//
//  SignupViewController.swift
//  UniAppNew
//
//  Created by Kim on 17/11/20.
//

//
//  LoginViewController.swift
//  UniAppNew
//
//  Created by Kim on 11/11/20.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import Auth0
import Combine
import SVProgressHUD


class SignupViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var gSignIn: UIButton!
    @IBOutlet weak var fSignIn: UIButton!
    @IBOutlet weak var phoneSignIn: UIButton!
    
    private let fbAPIURL = "https://graph.facebook.com/v6.0"
    // https://graph.facebook.com/me?access_token=%@
    // Old:https://graph.facebook.com/v6.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        
        activityIndicator.alpha = 0
        /*
        let fkSignIn = FBLoginButton()
        fkSignIn.center = view.center
        view.addSubview(fkSignIn)
        //fSignIn.delegate = self
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
        */
        
        //updateButton(isLoggedIn: AccessToken.current != nil)
        //updateMessage(name: Profile.current?.name)
        
        //setupLoginButton()
        
    }
    
    private func setupLoginButton() {
        
        let loginButton = FBLoginButton(permissions: [.publicProfile, .email])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
    }
    
    @IBAction func GoogleSignIn(_ sender: Any) {

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        titleText.alpha = 0
        gSignIn.alpha = 0
        fSignIn.alpha = 0
        phoneSignIn.alpha = 0
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "Testing")
        
        if error != nil {
            return
        }
        
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            
            if error == nil {
                
                let db = Firestore.firestore()
                
                db.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
                    
                    let test = snapshot!.isEmpty
                    
                    print(test)
                    
                    if test == true {
                        
                        let uid = Auth.auth().currentUser!.uid
                        UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
                        
                        print("Registration")
                        
                        SVProgressHUD.dismiss()
                        
                        let RegistrationVC = self.storyboard?.instantiateViewController(identifier: Constants.RegistrationVC)
                        guard RegistrationVC != nil else { return }
                        self.view.window?.rootViewController = RegistrationVC
                        self.view.window?.makeKeyAndVisible()
                        
                        
                    }
                    
                    else {

                        print("User Signed in")
                        
                        //self.activityIndicator.stopAnimating()
                        SVProgressHUD.dismiss()
                        
                        let uid = Auth.auth().currentUser!.uid
                        UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
                        
                        let TabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.TabBarVC)
                        guard TabBarVC != nil else { return }
                        self.view.window?.rootViewController = TabBarVC
                        self.view.window?.makeKeyAndVisible()

                    }
                    
                }
                
            }
            else {
                print(error!.localizedDescription)
                //print("hello")
            }
        })
    }
    
    @IBAction func FacebookSignIn(_ sender: Any) {
        
        let loginManager = LoginManager()
        
                loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                    
                    guard error == nil else {
                        print("Failed to login: \(error!.localizedDescription)")
                        return
                    }
                    
                    guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
                    
                    guard let result = result, !result.isCancelled else {
                        print("User cancelled login")
                        return
                    }
                    
                    self.titleText.alpha = 0
                    self.gSignIn.alpha = 0
                    self.fSignIn.alpha = 0
                    self.phoneSignIn.alpha = 0
                    
                    SVProgressHUD.setDefaultStyle(.dark)
                    SVProgressHUD.show(withStatus: "Testing")
                    
         
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    
                    // Perform login by calling Firebase APIs
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        if let error = error {
                            
                            print("Login error: \(error.localizedDescription)")
                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            return
                            
                        }else {
                            
                            
                            let db = Firestore.firestore()
                            
                            db.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
                                
                                let test = snapshot!.isEmpty
                                
                                //print(test)
                                
                                
                                if test == true {
                                    
                                    let uid = Auth.auth().currentUser!.uid
                                    UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    print("Registration")
                                    let RegistrationVC = self.storyboard?.instantiateViewController(identifier: Constants.RegistrationVC)
                                    guard RegistrationVC != nil else { return }
                                    self.view.window?.rootViewController = RegistrationVC
                                    self.view.window?.makeKeyAndVisible()
                                    
                                }
                                
                                else {
                                    
                                    print("User Signed in")
                                    
                                    let uid = Auth.auth().currentUser!.uid
                                    UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    let TabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.TabBarVC)
                                    guard TabBarVC != nil else { return }
                                    self.view.window?.rootViewController = TabBarVC
                                    self.view.window?.makeKeyAndVisible()
                                    
                                }
                                
                            }
                            
                        }
                    })
                }
    }

    
    @IBAction func textButton(_ sender: Any) {
        
        // 1
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
            // Access token available -- user already logged in
            // Perform log out
            
            // 2
            loginManager.logOut()
            updateButton(isLoggedIn: false)
            updateMessage(name: nil)
        }
        else {
            // Access token not available -- user already logged out
            // Perform log in
            
            // 3
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                
                // 4
                // Check for the error
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                // 5
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                
                // Successfully logged in
                // 6
                self.updateButton(isLoggedIn: true)
                
                // 7
                Profile.loadCurrentProfile { (profile, error) in
                    self.updateMessage(name: Profile.current?.name)
                }
                
            }
        }
        
    }
    
    private func updateButton(isLoggedIn: Bool) {
        let title = isLoggedIn ? "Log out" : "Log in"
        fSignIn.setTitle(title, for: .normal)
    }
    
    private func updateMessage(name:String?) {
        guard let name = name else {
            titleText.text = "Please log in with FB"
            return
        }
        titleText.text = "Hello, \(name)!"
    }
    
}


extension SignupViewController {
    
    private func fetch(url: URL) -> AnyPublisher<[String: Any], URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated)) // Execute the request on a background thread
            .receive(on: DispatchQueue.main) // Execute the sink callbacks on the main thread
            .compactMap { try? JSONSerialization.jsonObject(with: $0.data) as? [String: Any] } // Get a JSON dictionary
            .eraseToAnyPublisher()
    }

    private func fetchSessionAccessToken(appId: String, accessToken: String) -> AnyPublisher<String, URLError> {
        var components = URLComponents(string: "\(fbAPIURL)/oauth/access_token")!
        components.queryItems = [URLQueryItem(name: "grant_type", value: "fb_attenuate_token"),
                                 URLQueryItem(name: "fb_exchange_token", value: accessToken),
                                 URLQueryItem(name: "client_id", value: appId)]

        return fetch(url: components.url!)
            .compactMap { $0["access_token"] as? String } // Get the Session Access Token
            .eraseToAnyPublisher()
    }
    
    private func fetchProfile(userId: String, accessToken: String) -> AnyPublisher<[String: Any], URLError> {
        var components = URLComponents(string: "\(fbAPIURL)/\(userId)")!
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken),
                                 URLQueryItem(name: "fields", value: "first_name,last_name,email")]

        return fetch(url: components.url!)
    }
    
    fileprivate func login(with accessToken: FBSDKLoginKit.AccessToken) {
        
        // Get the request publishers
            let sessionAccessTokenPublisher = fetchSessionAccessToken(appId: accessToken.appID,
                                                                      accessToken: accessToken.tokenString)
            let profilePublisher = fetchProfile(userId: accessToken.userID, accessToken: accessToken.tokenString)

            // Start both requests in parallel and wait until all finish
            _ = Publishers
                .Zip(sessionAccessTokenPublisher, profilePublisher)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                }, receiveValue: { sessionAccessToken, profile in
                    // Perform the token exchange
                    Auth0
                        .authentication()
                        .login(facebookSessionAccessToken: sessionAccessToken, profile: profile)
                        .start { result in
                            switch result {
                            case .success(let credentials): print(credentials) // Auth0 user credentials 🎉
                            case .failure(let error): print(error)
                        }
                    }
                })
        
    }
    
}


extension SignupViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            guard error == nil, let accessToken = result?.token else {
                return print(error ?? "Facebook access token is nil")
            }

            login(with: accessToken)
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("Logged out")
    }
    
}

extension UIAlertController {
    
    static func show(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    
}
