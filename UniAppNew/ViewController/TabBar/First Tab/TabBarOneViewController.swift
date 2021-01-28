//
//  TabBarOneViewController.swift
//  UniAppNew
//
//  Created by Kim on 25/11/20.
//

import UIKit
import Firebase
import InstantSearch


class TabBarOneViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var text: UILabel!
    @IBOutlet weak var testButton: UIButton!
    
    
    private var postsModel = PostsModel()
    private var posts = [Post]()
    private var appuser = AppUser()
    private var comments = [Comment]()
    private var photos = [Photo]()
    private var lastContentOffset: CGFloat = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseManager.shared.test()
        
        addRefreshControl()
        
        print("Loal")
        LocalStorageService.checkUserv1(completion: { (bool) in
            self.checkProfile(n: bool)
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        postsModel.delegate = self
        
        //text.text = Auth.auth().currentUser?.uid
        //print(Auth.auth().currentUser?.uid)
        //print(appuser.username)
        

        postsModel.getPost()
        //.getProfile()
        
        // Set thr zero height table view
        tableView.tableFooterView = UIView()
        
        print("Before")
        print(LocalStorageService.loadUser()!)
        
        // User defailt saving
        UserService.testAppUser(UID: Auth.auth().currentUser!.uid) { (Appuser) in
        }
        
        print("After")
        print(LocalStorageService.loadUser()!)
        
        PhotoModel.retrievePhotos { (retrievedPhotos) in
            
            self.photos = retrievedPhotos
            self.tableView.reloadData()
            
        }
        reloadInputViews()
        setUpUI()
    }
    
    func setUpUI() {
        navigationItem.title = "Home"
    }
    
    func checkProfile(n: Bool) {
        
        if n == false {
            
            let uid = Auth.auth().currentUser!.uid
            UserDefaults.standard.setValue(uid, forKey: Constants.LocalStorage.userIdkey)
            print("Registration")
            let RegistrationVC = self.storyboard?.instantiateViewController(identifier: Constants.RegistrationVC)
            guard RegistrationVC != nil else { return }
            self.view.window?.rootViewController = RegistrationVC
            self.view.window?.makeKeyAndVisible()
            
            //guard RegistrationVC != nil else { return }
            //view.window?.rootViewController = RegistrationVC
            //view.window?.makeKeyAndVisible()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let postVC = segue.destination as! PostViewController
        //postVC.postsModel = self.postsModel
        
        //let postDetailsVC = segue.destination as! PostDetailsViewController
        
        if (segue.identifier == "postDetailsVC") {
            
            let postDetailsVC = segue.destination as! PostDetailsViewController
            
            if tableView.indexPathForSelectedRow != nil {
                
                postDetailsVC.post = posts[tableView.indexPathForSelectedRow!.row]
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                
            }

            postDetailsVC.postsModel = self.postsModel
        }
        
        else if (segue.identifier == "postVC") {
            
            let postVC = segue.destination as! PostViewController
            postVC.postsModel = self.postsModel
            
        }
        
        else if (segue.identifier == "postDetailsNPVC") {
            
            let nPostDetailsVC = segue.destination as! NoPicPostViewController
            
            if tableView.indexPathForSelectedRow != nil {
                
                nPostDetailsVC.post = posts[tableView.indexPathForSelectedRow!.row]
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                
            }

            nPostDetailsVC.postsModel = self.postsModel
        }

    }
    
    
    @IBAction func goToTapOne(_ sender: UIStoryboardSegue) {
    }
    
    // MARK: - Refresh
    
    func addRefreshControl() {
        
        // Create refresh control
        let refresh = UIRefreshControl()
        
        // Set target
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        
        // Add to tableview
        self.tableView.addSubview(refresh)
    }

    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        
        // Call the photo model
        PhotoModel.retrievePhotos { (newPhotos) in
            
            // Assign new photos to our photos property
            self.photos = newPhotos
            
            DispatchQueue.main.async {
                
                // Refresh table view
                self.tableView.reloadData()
                
                // Stop the spinner
                refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func pressed(sender: UIButton) {
//        print("working")
//        tableView.tableFooterView?.alpha = 0
//        tableView.isHidden = true

//        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {
//            self.tableView.tableFooterView!.isHidden = true
//            self.tableView.tableFooterView!.alpha = 0
//        }, completion: nil)
        
//        let postVC = PostViewController()
//        self.navigationController?.pushViewController(postVC, animated: true)
        
        let PostVC = self.storyboard?.instantiateViewController(identifier: "PostVC")
        guard PostVC != nil else { return }
//        self.view.window?.rootViewController = PostVC
//        self.view.window?.makeKeyAndVisible()
        //self.present(PostVC!, animated: true, completion: nil)
        self.navigationController?.pushViewController(PostVC!, animated: true)
        
        
    }
    
    func tableViewFooter() {
        
    }

}

extension TabBarOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if posts[indexPath.row].imageLinks != [nil] && posts[indexPath.row].imageLinks.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell
            
            let post = self.posts[indexPath.row]
            
            cell?.displayPost(post: post)
            return cell!
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestingCell", for: indexPath) as? TestingTableViewCell
            
            let post = self.posts[indexPath.row]
            
            cell?.displayPostWithOutImage(post: post)
            
            return cell!
        }
        
//        let titleLabel = cell.viewWithTag(1) as? UILabel
//        titleLabel?.text = posts[indexPath.row].title
//
//        let imageView = cell.viewWithTag(2) as? UIImageView
//
//        if posts[indexPath.row].imageLinks != nil && posts[indexPath.row].imageLinks.count > 0 {
//
//            PhotoModel.downloadImages(imageUrls: [posts[indexPath.row].imageLinks.first!]) { (image) in
//                imageView?.image = image[0]
//            }
//
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {


        return 50
    }



    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footerView = UIView()
        let button = UIButton()
        tableView.tableFooterView = footerView
        let image = UIImage(named: "message") as UIImage?

        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 50)
        button.frame = CGRect(x: footerView.frame.maxX - 10, y: footerView.frame.midY - 25, width: 50, height: 50)
        button.setTitle("T", for: .normal)
        button.backgroundColor = .black
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        footerView.addSubview(button)

        return footerView
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            //print("Moving Up")
            //tableView.tableFooterView?.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.tableView.tableFooterView?.alpha = 1
            }
        }
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            //print("Moving Down")
            UIView.animate(withDuration: 0.5) {
                self.tableView.tableFooterView?.alpha = 0
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

extension TabBarOneViewController: PostsModelProtocol {
    
    func profileRetrieved(appUser: AppUser) {
        self.appuser = appUser
    }
    
    func postsRetrieved(posts: [Post]) {
        
        self.posts = posts
        tableView.reloadData()
    }
    
}


