//
//  PostTableViewCell.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 24.03.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with post: Post) {
        self.postTextLabel.text = post.text
        self.postTextLabel.numberOfLines = 0
        self.postTextLabel.contentMode = .scaleToFill
    }
    
}
