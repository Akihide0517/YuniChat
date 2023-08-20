//
//  Post.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/11.
//
import Foundation
import Firebase

struct Post {
    var content: String
    let postID: String
    let senderID: String
    let createdAt: Timestamp
    let updatedAt: Timestamp

    init(data: [String: Any]) {
        content = data["content"]  as! String
        postID = data["postID"] as! String
        senderID = data["senderID"] as! String
        createdAt = data["createdAt"] as! Timestamp
        updatedAt = data["updatedAt"] as! Timestamp
        print(content)
    }
}
