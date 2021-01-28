//
//  PhotoViewController.swift
//  UniAppNew
//
//  Created by Kim on 7/12/20.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoTableView: UITableView!
    
    // PhotoDetailsVC
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        // Add pull to refresh
        addRefreshControl()

        PhotoModel.retrievePhotos { (retrievedPhotos) in
            self.photos = retrievedPhotos
            self.photoTableView.reloadData()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "photoDetailsVC") {
            
            let photoDetailsVC = segue.destination as! PhotoDetailsViewController
            
            if photoTableView.indexPathForSelectedRow != nil {
                
                photoDetailsVC.photos = photos[photoTableView.indexPathForSelectedRow!.row]
                photoTableView.deselectRow(at: photoTableView.indexPathForSelectedRow!, animated: false)
                
            }

        }
        
    }
    
    @IBAction func goToPhotoView(_ sender: UIStoryboardSegue) {
    }
    
    
    func addRefreshControl() {
        
        // Create refresh control
        let refresh = UIRefreshControl()
        
        // Set target
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        
        // Add to tableview
        self.photoTableView.addSubview(refresh)
    }

    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        
        // Call the photo model
        PhotoModel.retrievePhotos { (newPhotos) in
            
            // Assign new photos to our photos property
            self.photos = newPhotos
            
            DispatchQueue.main.async {
                
                // Refresh table view
                self.photoTableView.reloadData()
                
                // Stop the spinner
                refreshControl.endRefreshing()
            }
        }
    }
    
}


extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a Photo Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo Cell", for: indexPath) as? PhotoTableViewCell
        
        // Get the photo this cell is displaying
        let photo = self.photos[indexPath.row]
        //print(photo)
        
        // Call display the method of the cell
        cell?.displayPhoto(photo: photo)

        // Return the cell
        return cell!
    }

    
}
