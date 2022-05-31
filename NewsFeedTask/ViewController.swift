//
//  ViewController.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import UIKit
import Combine


class ViewController: UIViewController {

    let sections = Bundle.main.decode([Section].self, from: "newsFeed.json")
    
    var collectionView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<Section, NewsFeed>?

    
    var isConnected:Bool = false
    private var connectivitySubscriber:AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConnectivitySubscribers()
        
        initCollectionView()
        createDataSource()
        reloadData()
    }

    func initCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(LatestNewsCell.self, forCellWithReuseIdentifier: LatestNewsCell.reuseIdentifier)
        collectionView.register(MoreNewsCell.self, forCellWithReuseIdentifier: MoreNewsCell.reuseIdentifier)
    }
    
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with item: NewsFeed, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }

        cell.configure(with: item)
        return cell
    }
    
    
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, NewsFeed>(collectionView: collectionView) { collectionView, indexPath, item in
            switch self.sections[indexPath.section].type {
            case "Latest News":
                return self.configure(LatestNewsCell.self, with: item, for: indexPath)
            case "More News":
                return self.configure(MoreNewsCell.self, with: item, for: indexPath)
            default:
                return self.configure(MoreNewsCell.self, with: item, for: indexPath)
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }

            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            if section.title.isEmpty { return nil }

            sectionHeader.title.text = section.title
            return sectionHeader
        }
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsFeed>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.newsItems, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]

            switch section.type {
            case "Latest News":
                return self.createLatestNewsSection(using: section)
            case "More News":
                return self.createMoreNewsSection(using: section)
            default:
                return self.createMoreNewsSection(using: section)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }

    
    func createLatestNewsSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }
    
    
    
    func createMoreNewsSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSectionHeader = createSectionHeader()
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }

    

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    
    
    func setUpConnectivitySubscribers() {
        
        connectivitySubscriber = ConnectivityMananger.shared().$isConnected.sink(receiveValue: { [weak self](isConnected) in
            //print(isConnected ? "Online" : "Offline")
            self?.isConnected = isConnected
            self?.update()
        })
    }
    

    func update() {
        if isConnected {
            //Fetch from network
            print("network")
        }else{
            //Fetch from local
            print("local")
        }
    }
    
}








//{
//    "id": 1,
//    "type": "Stocks",
//    "title": "Stocks",
//    "stocksItems": [
//        "FORD", 72.19042874981784
//        "FORD", -211.5509976763925
//        "NVDA", 30.999642050562386
//        "NVDA", -150.5328741940824
//        "AMD", -117.59246397277423
//        "ACN", 70.81894630569406
//    ],
//    "newsItems": []
//},
