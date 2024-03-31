//
//  CustomTableViewCell.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/10/03.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var TweetImage: UIImageView!
   
    
    @IBOutlet weak var TweetName: UILabel!
    @IBOutlet weak var TweetText: UILabel!
    @IBOutlet weak var TweetTime: UILabel!
    @IBOutlet weak var TweetLike: UILabel!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
