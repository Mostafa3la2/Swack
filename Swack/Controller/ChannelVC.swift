//
//  ChannelVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/22/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: AvatarCircleImg!
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        channelTableView.delegate = self
        channelTableView.dataSource = self
        self.revealViewController().rearViewRevealWidth=self.view.frame.size.width-60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        SocketService.instance.getChannel { (success) in
            if success{
            self.channelTableView.reloadData()
            }
        }
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelID != MessageService.instance.selectedChannel?.channelid && AuthService.instance.isLoggedIn{
                MessageService.instance.unreadChannels.append(newMessage.channelID)
                self.channelTableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile,animated: true,completion: nil)
        }else{
        performSegue(withIdentifier: LOGIN, sender: nil)
        }
    }
    @objc func userDataDidChange(_ notif : Notification){
       setupUserInfo()
    }
    @objc func channelsLoaded(_ notif:Notification){
        channelTableView.reloadData()
    }
    @IBAction func addChannel(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
        let channel = AddChannelVC()
        channel.modalPresentationStyle = .custom
            present(channel,animated: true,completion: nil)}
        
    }
    func setupUserInfo(){
        if (AuthService.instance.isLoggedIn){
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named:UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService
                .instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        }else{
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named:"menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            channelTableView.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = channelTableView.dequeueReusableCell(withIdentifier: "channelCell",for : indexPath) as? ChannelCell{
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        return ChannelCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel=channel
        if MessageService.instance.unreadChannels.count>0{
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.channelid}
        }
        let index = IndexPath(row:indexPath.row,section:0)
        channelTableView.reloadRows(at: [index], with: .none)
        channelTableView.selectRow(at: index, animated: false, scrollPosition: .none)
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
}
