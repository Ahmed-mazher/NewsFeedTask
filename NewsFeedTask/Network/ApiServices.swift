//
//  ApiServices.swift
//  MoviesApp
//
//  Created by Front Tech on 19/05/2022.
//

import Foundation
import Combine
import Alamofire

protocol NewsServiceProtocol {
    func fetchNews() -> Future<ArticleModel, Error>
}



class APIServices: NewsServiceProtocol {
    
    
    
    private var task: AnyCancellable? = nil
    
    
    func fetchNews() -> Future<ArticleModel, Error>{
        
        return Future { promise in
            self.task = AF.request("https://saurav.tech/NewsAPI/everything/cnn.json")
                .publishDecodable(type: ArticleModel.self)
                .sink { (completion) in
                    switch completion{
                    case . finished:
                        ()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { (response) in
                    switch response.result{
                    case .success(let model):
                        promise(.success(model))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
        
        
    }
    
}

