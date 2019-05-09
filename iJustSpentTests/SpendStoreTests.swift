//  Copyright © 2019 David New. All rights reserved.

import XCTest
import Foundation
import RxSwift
import RxCocoa
import os.log


@testable import iJustSpent

class SpendStoreTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    let spendStore = SpendStore()
    
    func testExample() {
        
        let getTotalByDayExpectation = XCTestExpectation(description: "getTotalByDayExpectation")


        Observable.just( SpendDateAndValue(date: Date(), units: 25, subUnits: 64)).bind(to: spendStore.newSpendInput).disposed(by: disposeBag)
        spendStore.spendOutput.subscribe(onNext: {_ in print ("start")}).disposed(by: disposeBag)
        spendStore.spendOutput.subscribe(onNext: {(spendDateAndValueArray : [SpendDateAndValue]) in
            _ = spendDateAndValueArray.map{ ( spendDateAndValue : SpendDateAndValue) in
                print("Date: \(spendDateAndValue.date!)  Units: \(spendDateAndValue.units) Sub Units: \(spendDateAndValue.subUnits)")
            }
        }).disposed(by: disposeBag)
        spendStore.spendOutput.subscribe(onNext: {_ in print ("end")}).disposed(by: disposeBag)
        
        spendStore.spendOutput.subscribe(onNext: {
            print("total by day")
            print(GetTotalByDayForTableView.getTotalByDayForTableView(spendDateAndValueArray: $0))
            print("total by day end")
            getTotalByDayExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        spendStore.send()

        wait(for: [getTotalByDayExpectation], timeout: 5)

    }

}

