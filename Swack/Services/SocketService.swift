//
//  SocketService.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/29/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import SocketIO

var manager:SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!)
var socket:SocketIOClient = manager.defaultSocket
class SocketService: NSObject {
    override init(){
        super.init()
        
        
    }
    static let instance = SocketService()
    
    
    func establishConnection(){
        socket.connect()
    }
    func closeConnection(){
        socket.disconnect()
    }
    func addChannel(channelTitle:String,channelDesc:String,completion:@escaping CompletionHandler){
        
        socket.emit("newChannel", channelTitle,channelDesc)
        completion(true)
    }
    func getChannel(completion : @escaping CompletionHandler){
        socket.on("channelCreated") { (data, ack) in
            guard let channelTitle = data[0] as? String else{return}
            guard let channelDesc = data[1] as? String else {return}
            guard let channelID = data[2] as? String else {return}
            let channel = Channel(channelid: channelID, channedDescription: channelDesc, channelTitle: channelTitle)
            MessageService.instance.channels.append(channel)
            completion(true)
            
        }
    }
    
    func addMessage(messageBody:String,userID:String,channelID:String,completion:@escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody,userID,channelID,user.name,user.avatarName,user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion:@escaping (_ newMessage:Message)-> Void){
        
        socket.on("messageCreated") { (data, ack) in
            guard let msgBody = data[0] as? String else{return}
            guard let userID = data[1] as? String else{return}
            guard let channelID = data[2] as? String else{return}
            guard let userName = data[3] as? String else{return}
            guard let userAvatar = data[4] as? String else{return}
            guard let userAvatarColor = data[5] as? String else{return}
            guard let msgID = data[6] as? String else{return}
            guard let timestamp = data[7] as? String else{return}
            let message = Message(message: msgBody, userName: userName, channelID: channelID, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: msgID, timeStamp: timestamp,userID:userID)
            completion(message)
         
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers:[String:String])->Void){
        socket.on("userTypingUpdate") { (data, ack) in
            guard let typingUsers = data[0] as? [String:String] else{return}
            completionHandler(typingUsers)
        }
    }
    
    func stopTyping(username:String,channelID:String,completion:@escaping CompletionHandler){
        socket.emit("stopType", username,channelID)
        completion(true)
    }
    func startTyping(username:String,channelID:String,completion:@escaping CompletionHandler){
        socket.emit("startType", username,channelID)
        completion(true)
    }
    
}
