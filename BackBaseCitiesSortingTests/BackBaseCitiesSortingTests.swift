//
//  BackBaseCitiesSortingTests.swift
//  BackBaseCitiesSortingTests
//
//  Created by Avinash on 03/07/21.
//

import XCTest
@testable import BackBaseCitiesSorting

class BackBaseCitiesSortingTests: XCTestCase {
    var viewController: ViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = ViewController()
        viewController.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testtextSearchLogic() {
        
        let searchExpectation = expectation(description: "searchExpectation")
        viewController.fetchData()
        viewController.searchBar( UISearchBar(), textDidChange: "Syden")
        XCTAssertEqual(viewController.filteredCityDetails.count, 2)
        viewController.searchBar( UISearchBar(), textDidChange: "AllahabadIndia")
        XCTAssertEqual(viewController.filteredCityDetails.count, 0)
        searchExpectation.fulfill()
        waitForExpectations(timeout: 5, handler: nil)
    }

}
