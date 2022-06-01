//
//  StockTickersCell.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import UIKit

class StockTickersCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "StockTickersCell"

    let title = UILabel()
    let numberLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)


        title.textAlignment = .center
        
        numberLabel.textColor = .green
        numberLabel.numberOfLines = 1
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont(name: "Futura-Medium", size: 14)


    let stackView = UIStackView(arrangedSubviews: [title, numberLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
        stackView.spacing = 2
    contentView.addSubview(stackView)

    NSLayoutConstraint.activate([

        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])

    
}
    
    func configure(with item: NewsFeed) {
        title.text = item.stockName
        if item.price! > 0.0{
            numberLabel.textColor = .green
        }else{
            numberLabel.textColor = .red
        }
        let a = String(format: "%.2f", item.price!)
        numberLabel.text = a+" USD"
    }

    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
}
