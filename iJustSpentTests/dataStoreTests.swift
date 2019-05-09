//  Copyright © 2019 David New. All rights reserved.

import XCTest
import Foundation
import RxSwift
import RxCocoa

@testable import iJustSpent

class dataStoreTests: XCTestCase {
    let disposeBag = DisposeBag()
    let dataStore = DataStore()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        dataStore.allSpendingOutput.subscribe(onNext: {_ in print ("start")}).disposed(by: disposeBag)
        //dataStore.spendingAllOutput.subscribe(onNext: {dateAndTotalArray in dateAndTotalArray.m\print (dateAndTotalArray)})
        dataStore.allSpendingOutput.subscribe(onNext: {(dateAndTotalArray : [DateAndTotal]) in
            _ = dateAndTotalArray.map{ (dateAndTotal : DateAndTotal) in
                print("Date: \(dateAndTotal.date)  Total: \(dateAndTotal.total)")
            }
        }).disposed(by: disposeBag)
        dataStore.allSpendingOutput.subscribe(onNext: {_ in print ("end")}).disposed(by: disposeBag)
        dataStore.sendAllSpending()
    }
}


