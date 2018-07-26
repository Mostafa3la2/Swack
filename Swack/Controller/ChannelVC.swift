//
//  ChannelVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/22/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: AvatarCircleImg!
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth=self.view.frame.size.width-60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
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
        }
    }
}
