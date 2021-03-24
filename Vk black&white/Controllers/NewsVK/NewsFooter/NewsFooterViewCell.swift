//
//  NewsFooterViewCell.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 20.03.2021.
//

import UIKit

class NewsFooterViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var likesControl: LikeControl!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var repostsButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.likesControl = nil
        self.commentsButton.setTitle("0", for: .normal)
        self.repostsButton.setTitle("0", for: .normal)
        self.viewsButton.setTitle("0", for: .normal)
    }
    
    func configure(with post: Post) {
        self.likesControl.likesCount = post.likesCount
        self.commentsButton.setTitle("\(post.commentConut)", for: .normal)
        self.repostsButton.setTitle("\(post.repostCount)", for: .normal)
        self.viewsButton.setTitle("1", for: .normal)
    }
    
}
