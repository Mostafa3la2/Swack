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
    func returnUIColor(components:String)->UIColor{
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r,g,b,a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        let defaultColor = UIColor.lightGray
        
        guard let un_r = r else{return defaultColor}
        guard let un_g = g else{return defaultColor}
        guard let un_b = b else{return defaultColor}
        guard let un_a = a else{return defaultColor}
        
        return UIColor(red: CGFloat(un_r.doubleValue), green: CGFloat(un_g.doubleValue), blue:CGFloat(un_b.doubleValue), alpha: CGFloat(un_a.doubleValue))
    }
    
    func logout(){
        avatarColor = ""
        avatarName = ""
        name = ""
        email = ""
        id = ""
        AuthService.instance.authToken = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
