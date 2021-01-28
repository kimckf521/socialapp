//
//  TestingTableViewCell.swift
//  UniAppNew
//
//  Created by Kim on 17/1/21.
//

import UIKit

class TestingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitleWithoutP: UILabel!
    
    var post: Post?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.y += 10
            frame.origin.x += 10
            frame.size.height -= 15
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }
    
    func displayPostWithOutImage(post: Post) {
        
        self.imageView?.image = nil
        
        self.post = post
        
        postTitleWithoutP.text = post.title
    }

}
