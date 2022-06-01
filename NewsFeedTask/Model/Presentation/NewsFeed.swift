//
//  NewsFeed.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import Foundation

struct NewsFeed : Codable, Hashable {
    let source : Source?
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
    let stockName : String?
    let price : Double?
    
    init(source: Source? = nil, author: String? = nil, title: String? = nil, description: String? = nil, url: String? = nil, urlToImage: String? = nil, publishedAt: String? = nil, content: String? = nil, stockName: String? = nil, price: Double? = nil){
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.stockName = stockName
        self.price = price
    }
    
    
}
struct Source : Codable, Hashable {
    let id : String?
    let name : String?
}
