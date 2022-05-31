//
//  SelfConfiguringCell.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: NewsFeed)
}
