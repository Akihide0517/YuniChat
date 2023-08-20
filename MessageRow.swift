//
//  MessageRow.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/12.
//

import SwiftUI

struct MessageRow: View {
    let message: String
    let isMyMessage: Bool
    let user: String
    let date: Date
    
    var body: some View {
        HStack {
            if isMyMessage {
                Spacer()
                
                VStack {
                    Text(message)
                        .padding(8)
                        .background(Color.red)
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
                    //Text(date.text)
                        .font(.callout)
                }
            } else {
                VStack(alignment: .leading) {
                    Text(message)
                        .padding(8)
                        .background(Color.green)
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
                    
                    HStack {
                        Text(user)
                        
                        //Text(date.text)
                            .font(.callout)
                    }
                }
                
                Spacer()
            }
        }
    }
}
