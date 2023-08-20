//
//  ChatRoom.swift
//  ChatAppWithFirebase
//
//  Created by Uske on 2020/03/29.
//  Copyright © 2020 Uske. All rights reserved.
//

import Foundation
import Firebase

class ChatRoom: Hashable {
    
    let latestMessageId: String
    let memebers: [String]
    let createdAt: Timestamp
    var unreadMessageCount: Int = 0
    var documentId: String?
    
    var latestMessage: Message?
    var partnerUser: User?
    
    init(dic: [String: Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.memebers = dic["memebers"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latestMessageId)
    }
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.latestMessageId == rhs.latestMessageId
    }
}
