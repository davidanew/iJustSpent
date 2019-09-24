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
    
    func testAddExampleData() {
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
    
    func testAddExampleDataScreenshot() {
        testClearUserData()
        addOneItem(newSpend: SpendDateAndValue(date: Date(), units: 5, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -1), units: 32, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -2), units: 43, subUnits: 23))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -3), units: 23, subUnits: 64))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -4), units: 45, subUnits: 10))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -5), units: 6, subUnits: 48))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -6), units: 5, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -7), units: 19, subUnits: 96))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -8), units: 23, subUnits: 45))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -9), units: 20, subUnits: 98))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -10), units: 0, subUnits: 56))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -11), units: 32, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -12), units: 43, subUnits: 23))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -13), units: 23, subUnits: 64))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -14), units: 45, subUnits: 10))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -15), units: 6, subUnits: 48))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -16), units: 5, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -17), units: 19, subUnits: 96))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -18), units: 23, subUnits: 45))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -19), units: 20, subUnits: 98))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -20), units: 0, subUnits: 56))
    }
    
    
    
    
    
    func testAddLimitDifferentDays(){
        testClearUserData()
        for index in 1...200 {
            addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * Double(-1 * index)), units: 5, subUnits: 95))
        }
    }
    
    func testAddDataForUITest(){
        testClearUserData()
        //for today and yesterday
        addOneItem(newSpend: SpendDateAndValue(date: Date(), units: 5, subUnits: 95))
        addOneItem(newSpend: SpendDateAndValue(date: Date().addingTimeInterval(dayInSeconds * -1), units: 10, subUnits: 01))
        //let c=Date(
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        //let someDateTime = formatter.date(from: "2016/10/08 22:31")
        //print(someDateTime)
        //print(someDateTime)
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2016/10/1 01:59"), units: 0, subUnits: 01))
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2016/10/1 01:10"), units: 0, subUnits: 02))
        //Sat 1 Oct 2016 $0:03
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2017/2/3 09:03"), units: 1, subUnits: 10))
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2017/2/3 09:04"), units: 1, subUnits: 10))
        //Fri 3 Feb 2017 $2:20
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2013/12/8 12:27"), units: 25, subUnits: 92))
        //Sun 8 Dec 2013 $25:92
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2010/3/10 13:23"), units: 123, subUnits: 64))
        //Wed 10 Mar 2010 $123:64
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2019/5/16 14:56"), units: 93, subUnits: 39))
        //Thu 16 May 2019 $93:39
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2019/9/14 15:31"), units: 999, subUnits: 23))
        //Sat 14 Sept 2019 $999:23
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2019/5/25 23:32"), units: 23, subUnits: 92))
        //Sat 25 May 2019 $23:92
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2019/3/30 05:23"), units: 56, subUnits: 19))
        //Sat 30 Mar 2019  $56:19
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2019/2/08 05:10"), units: 132, subUnits: 99))
        //Fri 8 Feb 2019 $132:99
        addOneItem(newSpend: SpendDateAndValue(date: formatter.date(from: "2019/1/1 12:01"), units: 163, subUnits: 01))
        //Tue 1 Jan 2019 $163:01

        Thread.sleep(forTimeInterval: 5.0)


    
    }
}

