//
//  NewsViewModelTests.swift
//  iScoopTests
//
//  Created by Taral Rathod on 18/02/22.
//

import XCTest
@testable import iScoop

class NewsViewModelTests: XCTestCase {

    var newsViewModel: NewsViewModel?

    var mockAPIResponse: MockAPIResponse!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIResponse = MockAPIResponse()
        mockAPIResponse.jsonFileName = "Topheadlines"
        newsViewModel = NewsViewModel(delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        newsViewModel = nil
        mockAPIResponse = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func test01() throws {
        newsViewModel?.fetchHeadlines(network: mockAPIResponse)
        
        XCTAssertTrue(mockAPIResponse.didFetchedHeadlines, "Fetch the data from the api service invoked")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension NewsViewModelTests: NewsProtocol {
    func headlinesReceived(headlines: TopHeadlines, isConnectionError: Bool) {
    }
}
