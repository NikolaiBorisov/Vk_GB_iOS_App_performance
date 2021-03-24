//
//  NewsHeaderViewCell.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 20.03.2021.
//

import UIKit

class NewsHeaderViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    
    @IBOutlet weak var avatarImageView: RoundingAvatar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
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
        self.avatarImageView.image = nil
        self.nameLabel.text = nil
        self.dateLabel.text = nil
    }
    
    func configure(with post: Post) {
        self.nameLabel.text = "Text"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        self.dateLabel.text = dateFormatter.string(from: post.date)
        
        self.avatarImageView.image = UIImage(named: "Ag3")
        
    }
    
}
