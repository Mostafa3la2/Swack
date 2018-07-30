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
    
}
