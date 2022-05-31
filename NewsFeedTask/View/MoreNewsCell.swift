//
//  MoreNewsCell.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//


import UIKit

class MoreNewsCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "MoreNewsCell"

    let date = UILabel()
    let title = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label

        date.font = UIFont.preferredFont(forTextStyle: .subheadline)
        date.textColor = .secondaryLabel

        descriptionLabel.numberOfLines = 4
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true


        //imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)


    let stackView = UIStackView(arrangedSubviews: [title, date, descriptionLabel, imageView])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
        stackView.spacing = 5
    contentView.addSubview(stackView)

    NSLayoutConstraint.activate([

        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])

    
}
    
    func configure(with item: NewsFeed) {
        title.text = item.title
        date.text = item.publishedAt
        descriptionLabel.text = item.description
        imageView.setImage(imageUrl: item.urlToImage ?? "")
    }

    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
}
