//
//  AvatarCircleImg.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/24/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

@IBDesignable
class AvatarCircleImg: UIImageView {
    
    override func awakeFromNib() {
        setUpView()
    }
    
    func setUpView(){
        self.layer.cornerRadius = self.frame.width
         / 2
        self.clipsToBounds = true
        
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }

}
