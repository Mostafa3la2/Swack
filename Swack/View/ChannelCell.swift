//
//  ChannelCell.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/28/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        }
        else{
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel:Channel){
        channelName.text = "#\(channel.channelTitle!)"
    }

}
