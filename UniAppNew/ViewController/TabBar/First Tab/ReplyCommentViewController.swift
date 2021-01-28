//
//  ReplyCommentViewController.swift
//  UniAppNew
//
//  Created by Kim on 1/12/20.
//

import UIKit
import Firebase

class ReplyCommentViewController: UIViewController {
    
    @IBOutlet weak var replyText: UITextView!
    
    var post:Post?
    var postsModel:PostsModel?
    var comment:Comment?
    var appuser:AppUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(appuser?.userEmail)
        //print(post?.postId)

    }
    
    override func viewWillLayoutSubviews() {

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func replyButton(_ sender: Any) {
        
        let reply = replyText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if reply == nil || reply == "" {
            return
        }
        
        let username = LocalStorageService.loadUser()?.userId
        
        if let username = username {
            
            let n = Comment(username: username, commentId: UUID().uuidString, content: reply!, createdAt: Date())
    
            self.comment = n
            
            self.postsModel?.saveComment(self.comment!, post!)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
}
