//
//  Message.swift
//  chatcan
//
//  Created by Can Babaoğlu on 31.05.2022.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
    
    public func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
