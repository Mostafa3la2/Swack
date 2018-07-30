//
//  MessageService.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/26/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class MessageService{
    
    static let instance = MessageService()
    private init(){
        
    }
    var channels = [Channel]()
    
    var selectedChannel : Channel?
    
    func findAllChannels(completion:@escaping CompletionHandler ){
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else{return}
                do{
                if let json = try JSON(data:data).array{
                    for item in json{
                        let name = item["name"].stringValue
                        let channenDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelid: id, channedDescription: channenDescription, channelTitle: name)
                        self.channels.append(channel)
                        
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                }
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
    func clearChannels(){
        channels.removeAll()
    }
    
}
