//
//  LatestNewsCell.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import UIKit
import SwiftUI

class LatestNewsCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "LatestNewsCell"

    
    let title = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        

        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.textColor = .black
        title.numberOfLines = 2

        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        let stackView = UIStackView(arrangedSubviews: [title, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        stackView.setCustomSpacing(10, after: title)
    }

    func configure(with item: NewsFeed) {
        title.text = item.title
        imageView.setImage(imageUrl: item.urlToImage ?? "")
    }

    required init?(coder: NSCoder) {
        fatalError("Not happening")
    }
}
