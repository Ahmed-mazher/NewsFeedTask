//
//  NewsFeedViewModel.swift
//  NewsFeedTask
//
//  Created by Rivile on 6/1/22.
//

import Foundation
import Combine
import UIKit
import CoreData

class NewsFeedViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @Published var sections = [Section]()
    
    @Published var historyItems:[History] = []
    
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
        
        DispatchQueue.main.async {
            //Delete saved Local
            self.DeleteStock()
            // save new 10 items
            let historyStock = b
            for item in historyStock{
                self.createStock(item: item)
            }
        }
        
        let a = Section(id: 1, type: "Stocks", title: "Stocks", newsItems: b)
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
                
                DispatchQueue.main.async {
                    //Delete saved Local
                    self.DeleteHistory()
                    // save new 10 items
                    let historyNews = article.articles?[89...98]
                    let someMoreNewsArray: [NewsFeed] = Array(historyNews!)
                    for item in someMoreNewsArray{
                        self.createHistory(item: item)
                    }
                }
                
                
                
                var newSection: [Section] = []
                let firstFive = self.getLatestNewsArr(article: article)
                newSection.append(firstFive)
                
                let moreNews = self.getMoreNewsArr(article: article)
                newSection.append(moreNews)
                
                self.sections = newSection
                
            }).store(in: &token)
    }
    
    func getLatestNewsArr(article: ArticleModel)-> Section{
        let fisFive = article.articles?[0...4]
        let someTagsArray: [NewsFeed] = Array(fisFive!)
        let a = Section(id: 2, type: "Latest News", title: "Latest News", newsItems: someTagsArray)
        return a
    }
    
    func getMoreNewsArr(article: ArticleModel)-> Section{
        let moreNews = article.articles?.dropFirst(5)
        let someMoreNewsArray: [NewsFeed] = Array(moreNews!)
        let b = Section(id: 3, type: "More News", title: "More News", newsItems: someMoreNewsArray)
        return b
    }
    
    func getHistoryArr(article: ArticleModel)-> Section?{
        guard (article.articles?.isEmpty) != nil else {return nil}
        let moreNews = article.articles?[90...99]
        let someMoreNewsArray: [NewsFeed] = Array(moreNews!)
        let b = Section(id: 3, type: "History", title: "History", newsItems: someMoreNewsArray)
        return b
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
    
    
    // MARK: - Core Data
    
    
    func createHistory(item: NewsFeed){
        let newItem = History(context: context)
        newItem.title = item.title
        newItem.imageDescription = item.description
        newItem.imageUrl = item.urlToImage
        newItem.date = item.publishedAt
        
        //save to core data
        do{
            try self.context.save()
        }catch{
            print(error)
        }
    }
    
    func createStock(item: NewsFeed){
        let newItem = StockL(context: context)
        newItem.price = item.price ?? 0.0
        newItem.name = item.stockName
        
        //save to core data
        do{
            try self.context.save()
        }catch{
            print(error)
        }
    }
    
    func DeleteHistory(){
        if let result = try? context.fetch(History.fetchRequest()) {
            for object in result {
                self.context.delete(object.self as NSManagedObject)
            }
        }
        
        //save to core data
        do{
            try self.context.save()
        }catch{
            print(error)
        }
    }
    func DeleteStock(){
        if let result = try? context.fetch(StockL.fetchRequest()) {
            for object in result {
                self.context.delete(object.self as NSManagedObject)
            }
        }
        
        //save to core data
        do{
            try self.context.save()
        }catch{
            print(error)
        }
    }
    
}
