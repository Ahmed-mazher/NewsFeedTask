//
//  NewsFeedViewModel.swift
//  NewsFeedTask
//
//  Created by Rivile on 6/1/22.
//

import Foundation
import Combine

class NewsFeedViewModel {
    @Published var sections = [Section]()
    
    var token = Set<AnyCancellable>()
    
    private let apiService: NewsServiceProtocol
    
    //DI
    init(apiService: NewsServiceProtocol = APIServices()){
        self.apiService = apiService
    }
    
    func getStocksData()->Section{
        var b:[NewsFeed] = []
        readStringFromURL(stringURL: "https://raw.githubusercontent.com/dsancov/TestData/main/stocks.csv").forEach { dataList in
            if !dataList.isEmpty {
                if let stockVo = dataList.randomElement() {
                    b.append(stockVo)
                }
            }
        }
        let a = Section(id: 1, type: "Stocks", title: "Stocks", newsItems: b)
        //sections.insert(a, at: 0)
        return a
    }
    
    func getNewsData(){
        apiService.fetchNews()
            .sink (receiveCompletion: { (completion) in
                switch completion{
                case . finished:
                    print("Publisher stoped observing")
                case .failure(let error):
                    print("any error hereee",error.localizedDescription)
                }
            }, receiveValue: { article in
                var newSection: [Section] = []
                let fisFive = article.articles?[0...4]
                let someTagsArray: [NewsFeed] = Array(fisFive!)
                let a = Section(id: 2, type: "Latest News", title: "Latest News", newsItems: someTagsArray)
                newSection.append(a)
                
                let moreNews = article.articles?.dropFirst(5)
                let someMoreNewsArray: [NewsFeed] = Array(moreNews!)
                let b = Section(id: 3, type: "More News", title: "More News", newsItems: someMoreNewsArray)
                newSection.append(b)
                
                self.sections = newSection
                
            }).store(in: &token)
    }
    
    
    // Read from String file
    func readStringFromURL(stringURL:String)-> [[NewsFeed]]{
        var stockList : [NewsFeed] = []
        do {
            let url = NSURL(string: stringURL)
            let file = try String(contentsOf: url! as URL)
            var rows = file.components(separatedBy: .newlines)
            rows.remove(at: 0)
            rows.forEach { item in
                let components = item.components(separatedBy: ", ")
                stockList.append(NewsFeed(stockName: components.first, price: Double(components.last ?? "0.0")))
            }
        } catch {
            print(error)
        }
        return stockList.group { $0.stockName }
    }
    
}
