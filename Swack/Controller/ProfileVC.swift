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
    
    @IBOutlet weak var editNameBtn: UIButton!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var usermail: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    var editBtnState = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logout()
        NotificationCenter.default.post(name:NOTIF_USER_DATA_DID_CHANGE,object:nil)
        
       
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editNamePressed(_ sender: Any) {
        if editBtnState == 0{
            editBtnState += 1
            editNameBtn.setTitle("Finish", for: .normal)
            name.isUserInteractionEnabled = true
            }else{
            guard let newName = name.text, name.text != "" else{return}
            AuthService.instance.editUsername(name: newName) { (success) in
                self.editBtnState = 0
                self.editNameBtn.setTitle("Edit", for: .normal)
                self.name.isUserInteractionEnabled = false
                //just a test
                NotificationCenter.default.post(name:NOTIF_USER_EDITED_NAME,object:nil)
            }
        }
    }
    
    func setupView(){
        name.attributedPlaceholder = NSAttributedString(string:UserDataService.instance.name,attributes:[NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 1)])
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        usermail.text = UserDataService.instance.email
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeOnTap(_:)))
        
        bgView.addGestureRecognizer(closeTouch)
        
    }
    @objc func closeOnTap(_ recognizer:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }

}
