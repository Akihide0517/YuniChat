//
//  MessageView.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/12.
//
import SwiftUI

struct MessageView: View {
    var name = ""
    @ObservedObject var messageVM = MessageViewModel()
    @State var typeMessage = ""
    
    var body: some View {
        VStack {
            List(messageVM.messages, id: \.id) {i in
                if i.name == self.name {
                    MessageRow(message: i.message, isMyMessage: true, user:i.name, date: i.createAt)
                } else {
                    MessageRow(message: i.message, isMyMessage: false, user:i.name, date: i.createAt)
                }
            }
            .navigationBarTitle("Chats",displayMode: .inline)
            HStack {
                TextField("Message", text: $typeMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.messageVM.addMessage(message: self.typeMessage, user: self.name)
                    self.typeMessage = ""
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                }
            }
            .padding()
        }
    }
}
