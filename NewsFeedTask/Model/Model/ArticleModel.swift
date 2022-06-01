
//
//  ArticleModel.swift
//  NewsFeedTask
//
//  Created by Rivile on 6/1/22.
//

import Foundation
struct ArticleModel : Codable {
	let status : String?
	let totalResults : Int?
	let articles : [NewsFeed]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case totalResults = "totalResults"
		case articles = "articles"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
		articles = try values.decodeIfPresent([NewsFeed].self, forKey: .articles)
	}

}
