//
//  UserDataService.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/24/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation

class UserDataService{
    
    static let instance = UserDataService()
    
    private(set) public var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var name = ""
    public private(set) var email = ""
    
    private init(){}
    
    func setUserData(id:String,color:String,avatarName:String,email:String,name:String){
        self.id=id
        self.avatarColor=color
        self.avatarName=avatarName
        self.email=email
        self.name=name
    }
    func setAvatarName(avatarName:String){
        self.avatarName=avatarName
    }
    
}
