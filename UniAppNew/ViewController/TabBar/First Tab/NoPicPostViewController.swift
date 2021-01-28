//
//  NoPicPostViewController.swift
//  UniAppNew
//
//  Created by Kim on 21/1/21.
//

import UIKit

class NoPicPostViewController: UIViewController {

    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    
    var post:Post?
    var postsModel:PostsModel?
    var appuser:AppUser?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTitle.text = post?.title
        postContent.text = post?.content
        
        postsModel?.commentDelegate = self
        postsModel?.getComment(post!)
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        commentTableView.reloadData()
        
        commentTableView.estimatedRowHeight = 200
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

}

extension NoPicPostViewController: UITableViewDelegate, UITableViewDataSource {
    
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


extension NoPicPostViewController: CommentsProtocol {
    
    func commentsRetrieved(comments: [Comment]) {
        
        self.comments = comments
        print(comments)
        commentTableView.reloadData()
        
    }
    
}
