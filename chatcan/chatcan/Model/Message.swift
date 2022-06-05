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
    
    public func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
