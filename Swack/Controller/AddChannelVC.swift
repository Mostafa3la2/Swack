//
//  AddChannelVC.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/28/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelDesc: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelName = nameText.text , nameText.text != "" else{return}
        guard let channelDescStr = channelDesc.text , channelDesc.text != "" else{return}
        SocketService.instance.addChannel(channelTitle: channelName, channelDesc: channelDescStr) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func setupView(){
        nameText.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
        
        channelDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : PURPLE_PLACEHOLDER])
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(self.closeOnTap(_:)))

        bgView.addGestureRecognizer(closeTouch)
        
    }
    @objc func closeOnTap(_ recognizer:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
