//
//  PostDetailsViewController.swift
//  UniAppNew
//
//  Created by Kim on 30/11/20.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var postImageCollectionView: UICollectionView!
    
    
    var post:Post?
    var postsModel:PostsModel?
    var appuser:AppUser?
    var comments = [Comment]()
    var postImages: [UIImage] = []
    
//    let postImageCVC = PostImageCollectionViewCell.self

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(post!.postId)

        postTitle.text = post?.title
        postContent.text = post?.content
        
        postsModel?.commentDelegate = self
        postsModel?.getComment(post!)
        
        commentTableView.estimatedRowHeight = 200
        
        postImageCollectionView.dataSource = self
        postImageCollectionView.delegate = self
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        commentTableView.reloadData()
        
        downloadPictures()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        postsModel?.getComment(post!)
        commentTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "replyCommentVC") {
            
            let replyCommentVC = segue.destination as! ReplyCommentViewController
            replyCommentVC.postsModel = self.postsModel
            replyCommentVC.post = self.post
            replyCommentVC.appuser = self.appuser
            
        }
        
    }
    
    

    // MARK: - Download Pictures
    
    private func downloadPictures() {
        
        if post != nil && post?.imageLinks != nil {
            PhotoModel.downloadImages(imageUrls: post!.imageLinks) { (allImages) in
                
                if allImages.count > 0 {
                    
                    DispatchQueue.main.async {
                        self.postImages = allImages as! [UIImage]
                        self.postImageCollectionView.reloadData()
                    }
                }
            }
        }
    }

}

extension PostDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Number of commentd:\(comments.count)")
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CommentCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(21) as? UILabel
        let commentText = cell.viewWithTag(22) as? UITextView
        let dateLabel = cell.viewWithTag(23) as? UILabel
        let createdDate = comments[indexPath.row].createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        print(comments[indexPath.row].username)
        titleLabel?.text = comments[indexPath.row].username
        commentText?.text = comments[indexPath.row].content
        dateLabel?.text = formatter.string(from: createdDate)
        
        return cell
        
    }
}

extension PostDetailsViewController: CommentsProtocol {
    
    func commentsRetrieved(comments: [Comment]) {
        
        self.comments = comments
        print(comments)
        commentTableView.reloadData()
        
    }
    
}
    
extension PostDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages.count == 0 ? 1 : postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = postImageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PostImageCollectionViewCell
        
        cell.pageControl.numberOfPages = postImages.count
        
//        cell.pageControl.numberOfPages = postImages.count
//
        cell.pageControl.currentPage = indexPath.row
        
        if postImages.count > 0 {
            cell.setupImageWith(postImage: postImages[indexPath.row])
        }
        
        return cell
    }
    
}
