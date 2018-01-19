//
//  MessageTableViewCell.swift
//  cocoa
//
//  Created by Student on 19/01/18.
//  Copyright © 2018 KIS AGH. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var msgTime: UILabel!
    @IBOutlet weak var msgText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
