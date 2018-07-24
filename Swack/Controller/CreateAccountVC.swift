//
//  CreateAccountVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/23/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor : UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != ""{
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        loader.isHidden = false
        loader.startAnimating()
        guard let email = emailText.text ,emailText.text != "" else{return}
        guard let pass = passText.text , passText.text != "" else{return}
        guard let name = usernameText.text , usernameText.text != "" else{return}
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success{
                
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                        if success{
                            self.loader.stopAnimating()
                            self.loader.isHidden = true
                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                        }
                    })
                })
            }
        }
    }
    
    
    @IBAction func pickavatarPressed(_ sender: Any) {
        
        performSegue(withIdentifier: AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255))/255
        let g = CGFloat(arc4random_uniform(255))/255
        let b = CGFloat(arc4random_uniform(255))/255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        UIView.animate(withDuration: 0.2) {
            self.userImg.backgroundColor = self.bgColor
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    func setupView(){
        loader.isHidden = true
        
        usernameText.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
        
        emailText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
        
        passText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
}
