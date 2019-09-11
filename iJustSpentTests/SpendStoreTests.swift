//  Copyright © 2019 David New. All rights reserved.

import XCTest
import Foundation
import RxSwift
import RxCocoa
import os.log
import CoreData


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
            print(TableUtils.getTotalByDayForTableView(spendDateAndValueArray: $0))
            print("total by day end")
            getTotalByDayExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        spendStore.send()

        wait(for: [getTotalByDayExpectation], timeout: 5)

    }
    
    func testClearUserData() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Spend")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        
    }
    
    func testAddExampleData() {
        func addOneItem (newSpend : SpendDateAndValue) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newCoreDataSpend = Spend(context: context)
            newCoreDataSpend.date = newSpend.date
            newCoreDataSpend.units = newSpend.units
            newCoreDataSpend.subUnits = newSpend.subUnits
            do{
                try context.save()
            }
            catch {
                os_log("New item context save error")
                return
            }
        }
        let dayInSeconds : TimeInterval = 60*60*24
        
        addOneItem(newSpend: SpendDateAndValue(date: Date(), units: 5, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -1), units: 5, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -2), units: 6, subUnits: 23))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -3), units: 2, subUnits: 64))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -4), units: 3, subUnits: 10))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -5), units: 6, subUnits: 48))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -6), units: 3, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -7), units: 6, subUnits: 96))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -8), units: 100000, subUnits: 45))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -9), units: 20000, subUnits: 98))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -10), units: 0, subUnits: 56))
    }
}

