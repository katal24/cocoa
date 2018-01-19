//
//  Message.swift
//  cocoa
//
//  Created by Student on 19/01/18.
//  Copyright © 2018 KIS AGH. All rights reserved.
//

import Foundation

class Message {
    
    var timestamp: Date
    var message: String?
    var name: String?
    
    init(time: String, nam: String, msg: String) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datetime = dateFormate.date(from: time)
        
        timestamp = datetime!
        message = msg
        name = nam
        print(datetime ?? "aaa")
    }
    
}
