//
//  ChatVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/22/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
           
        }
        
       
    }
    @objc func userDataDidChange(_ notif : Notification){
        if AuthService.instance.isLoggedIn{
            OnLoginGetMessages()
        }else{
            channelNameLbl.text = "Please Log In"
        }
    }
    
    func OnLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success{
                //TODO
            }
        }
    }
    @objc func channelSelected(_ notif:Notification){
        updateWithChannel()
    }
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
    }
}
