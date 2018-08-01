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
        channelName.font = UIFont(name:"HelveticaNeue-Regular",size:17)
        for channelID in MessageService.instance.unreadChannels{
            if channelID == channel.channelid{
                channelName.font = UIFont(name:"HelveticaNeue-Bold",size:22)
            }
        }
    }

}
