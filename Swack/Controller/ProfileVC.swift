//
//  ProfileVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/25/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var usermail: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logout()
        NotificationCenter.default.post(name:NOTIF_USER_DATA_DID_CHANGE,object:nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        username.text = UserDataService.instance.name
        usermail.text = UserDataService.instance.email
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeOnTap(_:)))
        
        bgView.addGestureRecognizer(closeTouch)
        
    }
    @objc func closeOnTap(_ recognizer:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }

}
