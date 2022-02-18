//
//  NewsDetailsViewModelTest.swift
//  iScoopTests
//
//  Created by Taral Rathod on 19/02/22.
//

import XCTest
@testable import iScoop

class NewsDetailsViewModelTest: XCTestCase {

    var newsDetailsViewModel: NewsDetailsViewModel?

    var mockAPIResponse: MockAPIResponse!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIResponse = MockAPIResponse()
        mockAPIResponse.jsonFileName = "Likes"
        newsDetailsViewModel = NewsDetailsViewModel(delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        newsDetailsViewModel = nil
        mockAPIResponse = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func getArticles() -> Articles? {
        guard let data = mockAPIResponse.readLocalFile(forName: mockAPIResponse.jsonFileName) else {return nil}
        guard let headlines = mockAPIResponse.parse(jsonData: data, model: TopHeadline.self) else {return nil}
        guard let topHeadlines = CoreDataManager.sharedManager.insertTopHeadlines(headlines: headlines) else {return nil}
        guard let article = topHeadlines.articles?.array.first as? Articles else {return nil}
        return article
    }

    func test01() {
        guard let article = getArticles() else {return}
        newsDetailsViewModel?.fetchLikeAndComments(for: article,
                                                      network: mockAPIResponse)

        XCTAssertTrue(mockAPIResponse.didFetchedHeadlines, "Fetch the data from the api service invoked")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension NewsDetailsViewModelTest: NewsDetailsProtocol {
    func likesAndCommentsReceived(article: Articles) {
        print(article.likes ?? 0)
        print(article.comments ?? 0)
    }
}
