//
//  ChatVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/22/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var isTyping = false
   
    

    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var messageTextbox: UITextField!
    @IBOutlet weak var chatTableview: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUserLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.isHidden = true
        view.bindToKeyboard()
        chatTableview.delegate=self
        chatTableview.dataSource=self
        chatTableview.estimatedRowHeight = 80
        chatTableview.rowHeight = UITableViewAutomaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        SocketService.instance.getChannel { (success) in
            if success{
                self.chatTableview.reloadData()
                if MessageService.instance.messages.count > 0{
                    let index = IndexPath(row: MessageService.instance.messages.count-1, section: 1)
                    self.chatTableview.scrollToRow(at: index, at: .bottom, animated: false)
                }
            }
        }
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelID = MessageService.instance.selectedChannel?.channelid else{return}
            
            var names = ""
            var numOfTypers = 0
            for (typingUser,channel) in typingUsers{
                if typingUser != UserDataService.instance.name && channel == channelID{
                    if names == ""{
                        names = typingUser
                    }else{
                        names = "\(names), \(typingUser)"
                        
                    }
                    numOfTypers+=1
                }
               
                if numOfTypers > 0 && AuthService.instance.isLoggedIn == true{
                    debugPrint("this should appear")
                    var verb = "is"
                    if numOfTypers > 1{
                        var verb = "are"
                    }
                    
                    self.typingUserLbl.text = "\(names) \(verb) typing a message"
                    
                }else{
                    self.typingUserLbl.text = ""
                }
            }
        }
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
            chatTableview.reloadData()
        }
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    func OnLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success{
                if MessageService.instance.channels.count>0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.channelNameLbl.text = "No channels yet 😔"
                }
            }
        }
    }
    @objc func channelSelected(_ notif:Notification){
        updateWithChannel()
    }
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    func getMessages(){
        
        guard let channelID = MessageService.instance.selectedChannel?.channelid else{return}
        MessageService.instance.findAllMessagesForChannel(channelID: channelID) { (success) in
            if success{
                
                self.chatTableview.reloadData()
            }
        }
    }
    @IBAction func msgBoxEditing(_ sender: Any) {
        if messageTextbox.text == ""{
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.stopTyping(username: UserDataService.instance.name, channelID: (MessageService.instance.selectedChannel?.channelid)!) { (success) in
                
            }
        }else{
            if isTyping == false{
                sendBtn.isHidden = false
                SocketService.instance.startTyping(username: UserDataService.instance.name, channelID: (MessageService.instance.selectedChannel?.channelid)!) { (success) in
                    
                }
            }
            isTyping=true
        }
    }
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            guard let channelID = MessageService.instance.selectedChannel?.channelid else{return}
            guard let message = messageTextbox.text else{return}
            SocketService.instance.addMessage(messageBody: message, userID: UserDataService.instance.id, channelID: channelID) { (success) in
                if success{
                    self.messageTextbox.text = ""
                    self.messageTextbox.resignFirstResponder()
                    SocketService.instance.stopTyping(username: UserDataService.instance.name, channelID: (MessageService.instance.selectedChannel?.channelid)!) { (success) in
                        
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for : indexPath) as? MessageCell{
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }else{
            return MessageCell()}
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
