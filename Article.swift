//
//  Article.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/07/08.
//
import Foundation

struct ArticleList: Codable {
    let articles: [Article]
}

struct Article: Codable{
    let title:String
    let description:String
    let urlToImage:String
    let url:String
}
