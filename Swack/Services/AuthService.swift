//
//  AuthService.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/23/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class AuthService{
    
    static let instance = AuthService()
    
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken :String{
        get{
            
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userEmail:String{
        get{
            
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser(email:String,password:String,completion:@escaping CompletionHandler){
        
        let lowerCaseEmail=email.lowercased()
        
      
        let body:[String:Any] = [
            "email": lowerCaseEmail,
            "password": password
        
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil{
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email:String,password:String,completion:@escaping CompletionHandler){
        
        let lowerCaseEmail=email.lowercased()
        
        let body:[String:Any] = [
            "email": lowerCaseEmail,
            "password": password
            
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                do{
                    let json = try JSON(data: data)
                
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                self.isLoggedIn = true
                
                }catch let error as NSError{
                    debugPrint(error)
                }
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    private init(){}
    
    func createUser(name:String,email:String,avatarName:String,avatarColor:String,completion:@escaping CompletionHandler){
        let lowerCaseEmail=email.lowercased()
        
        let body:[String:Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
      
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
                
            }
        }
    }
    func findUserByEmail(completion:@escaping CompletionHandler){
        
        Alamofire.request(("\(URL_USER_BY_EMAIL)\(userEmail)"), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
                
            }
        }
        
    }
    
    func setUserInfo(data:Data){
        do{
            let json = try JSON(data: data)
            
            let id = json["_id"].stringValue
            let color = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            
            UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
            
            
        }catch let error as NSError{
            debugPrint(error)
        }
    }
    func editUsername(name:String,completion:@escaping CompletionHandler){
        if isLoggedIn{
            let user = UserDataService.instance
            user.setName(name: name)
        let body:[String:Any] = [
            "name":user.name,
            "email":user.email,
            "avatarName":user.avatarName,
            "avatarColor":user.avatarColor
            ]
            Alamofire.request("\(URL_EDIT_USER)\(UserDataService.instance.id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseString { (response) in
                if response.result.error == nil{
                    
                    //not reliable
                    //update the message sender name if he changes his name, however this is applied only locally and volatile
                    for  i in 0..<MessageService.instance.messages.count{
                   
                        if MessageService.instance.messages[i].userID == user.id{
                            MessageService.instance.messages[i].changeUsername(name: name)
                        }
                    }
                    debugPrint(response.result)
                    completion(true)
                }else{
                    debugPrint(response.error!)
                    completion(false)
                }
            }
        
        }
        
    }
}
