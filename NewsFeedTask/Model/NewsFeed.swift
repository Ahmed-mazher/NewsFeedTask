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
}
struct Source : Codable, Hashable {
    let id : String?
    let name : String?
}
