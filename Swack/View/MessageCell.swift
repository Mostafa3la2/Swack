//
//  MessageCell.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/30/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImage: AvatarCircleImg!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var msgBodyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(message:Message){
        msgBodyLbl.text = message.message
        usernameLbl.text = message.userName
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        
        guard var isoDate = message.timeStamp else{return}
        let splitter:NSString = NSString(string: isoDate)
        isoDate = splitter.substring(to:isoDate.count-5)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "d MMM, HH:mm"
        if let finalDate = chatDate{
            let finalDate = newFormatter.string(from: finalDate)
            timestampLbl.text = finalDate
        }
        
        
    }

}
