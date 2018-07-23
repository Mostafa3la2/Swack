//
//  RoundedBtn.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/23/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBtn: UIButton {

    @IBInspectable var cornerRadius:CGFloat = 3.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

    override func awakeFromNib() {
        self.setupView()
            
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = cornerRadius
    }

}
