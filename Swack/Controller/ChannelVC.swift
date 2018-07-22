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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth=self.view.frame.size.width-60
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: LOGIN, sender: nil)
    }
    

}
