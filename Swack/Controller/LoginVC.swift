//
//  LoginVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/23/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    @IBAction func loginPressed(_ sender: Any) {
        loader.isHidden = false
        loader.startAnimating()
        
        guard let email = emailText.text , emailText.text != "" else{return}
        guard let pass = passwordText.text , passwordText.text != "" else{return}
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success{
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success{
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.loader.stopAnimating()
                        self.loader.isHidden = true
                        MessageService.instance.findAllChannels(completion: { (success) in
                            
                        })
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: CREATE_ACCOUNT, sender: nil)
    }
    func setupView(){
        
        loader.isHidden = true
        
        emailText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
        
        passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
    }
    
}
