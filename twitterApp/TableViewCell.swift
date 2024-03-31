//
//  TableViewCell.swift
//  twitterApp
//
//  Created by Gomi Kouki on 2023/10/05.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var SearchImage: UIImageView!
    @IBOutlet weak var SearchName: UILabel!
    @IBOutlet weak var SearchProfile: UILabel!
    @IBOutlet weak var SearchID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
