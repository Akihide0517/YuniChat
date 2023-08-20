//
//  messageViewModel.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/12.
//
import Foundation
import FirebaseFirestore

struct messageDataType: Identifiable {
    var id: String
    var name: String
    var message: String
    var createAt: Date
}

class MessageViewModel: ObservableObject {
    @Published var messages = [messageDataType]()
    
    init() {
        let db = Firestore.firestore()
        
        db.collection("messages").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let snap = snap {
                for i in snap.documentChanges {
                    if i.type == .added {
                        let name = i.document.get("name") as! String
                        let message = i.document.get("message") as! String
                        let createdAt = i.document.get("createAt", serverTimestampBehavior: .estimate) as! Timestamp
                        let createDate = createdAt.dateValue()
                        let id = i.document.documentID
                        
                        //self.messages.append(messageElement(id: id, name: name, message: message, createAt: createDate))
                    }
                }
                // 日付順に並べ替えする
                self.messages.sort { before, after in
                    return before.createAt < after.createAt ? true : false
                }
            }
        }
    }
    
    func addMessage(message: String , user: String) {
        let data = [
            "message": message,
            "name": user,
            "createAt":FieldValue.serverTimestamp(),
        ] as [String : Any]
        
        let db = Firestore.firestore()
        
        db.collection("messages").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("success")
        }
    }
}
