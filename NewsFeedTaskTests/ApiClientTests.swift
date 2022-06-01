//
//  ApiClientTests.swift
//  NewsFeedTaskTests
//
//  Created by Rivile on 6/1/22.
//

import XCTest
@testable import NewsFeedTask
import OHHTTPStubs
import Combine

class ApiClientTests: XCTestCase {

    let apiService: NewsServiceProtocol = APIServices()
    
    var token = Set<AnyCancellable>()
    
    override func setUp() {
         super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() throws {
        //given
        stub { (urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("/everything/cnn.json") ?? false
        } response: { (urlRequest) -> HTTPStubsResponse in
            
            //let jsonModel = Bundle.main.decode(Section.self, from: "newsFeed.json")
            
            let jsonModel: [String:Any] = [
                "status": "ok",
                "totalResults": 99
                
            ]
            
            return HTTPStubsResponse(jsonObject: jsonModel, statusCode: 200, headers: nil)
        }
        var expectedJson: ArticleModel? = nil

        let exception = self.expectation(description: "Network Call Failed.")
        
        // when
        apiService.fetchNews()
            .sink (receiveCompletion: { (completion) in
                switch completion{
                case . finished:
                    print("Publisher stoped observing")
                case .failure(let error):
                    print("any error hereee",error.localizedDescription)
                }
            }, receiveValue: { article in
                expectedJson = article
                exception.fulfill()
                
            }).store(in: &token)
        
        
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(expectedJson)
        XCTAssertEqual(expectedJson?.totalResults, 99)
    }
}
