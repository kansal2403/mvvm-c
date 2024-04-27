//
//  Postcell.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 27/04/24.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var postIdLabel: UILabel!
    
    func configure(post: Post) {
        self.userNameLabel.text = post.title
        self.postIdLabel.text = "\(post.id)"
    }
}
