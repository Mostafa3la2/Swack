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
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailText.text ,emailText.text != "" else{return}
        guard let pass = passText.text , passText.text != "" else{return}
        guard let name = usernameText.text , usernameText.text != "" else{return}
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success{
                
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                        if success{
                            print(UserDataService.instance.avatarName,UserDataService.instance.name)
                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                        }
                    })
                })
                
                
            }
        }
    }
    
    
    @IBAction func pickavatarPressed(_ sender: Any) {
    }
    
    
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
