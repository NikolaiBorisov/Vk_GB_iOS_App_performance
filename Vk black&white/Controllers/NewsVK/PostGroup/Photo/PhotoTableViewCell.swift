//
//  PhotoTableViewCell.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 24.03.2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(post: Post) {
        
    }
    
}
