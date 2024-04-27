//
//  PostDetailsViewController.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 27/04/24.
//

import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var postInfo: UILabel!
    private let post: Post
    required init?(coder: NSCoder, post: Post) {
        self.post = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postInfo.text = "Selected Post name == \(post.title)"
    }
}
