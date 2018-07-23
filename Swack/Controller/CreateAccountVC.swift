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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailText.text ,emailText.text != "" else{return}
        guard let pass = passText.text , passText.text != "" else{return}
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success{print("registered user!")}
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
