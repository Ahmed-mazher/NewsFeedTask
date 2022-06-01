//
//  Section.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let newsItems: [NewsFeed]
}

