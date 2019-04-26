//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

class InputController {
    
    private let disposeBag = DisposeBag()
    //
    let spentLabelTextOutput  = BehaviorSubject<String>(value: "No Spending")
    //
    let collectionViewArrayOutput = BehaviorSubject<[String]>(value: ["1"])
    //
    let spentLabelSelectedInput = PublishSubject<Int>()
    //The options for spending that are displayed and are clickable
    private let spendValuesBase : [Int64] = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60,70,80,90,100]
    //TODO: Put these values in user defaults
    //Multiply spend options for different currency
    //Only Int supported at the moment
    private let multiplier : Int64 = 1
    private let currencySymbol : String = "£"
    //Handles storing and upadating of the spending
    private let dataStore = DataStore()
    //Calculate spend options as a number
    private var spendValues : [Int64] {
        get {
            return spendValuesBase.map {$0 * multiplier}
        }
    }
    //FIXME: remove intermediate calculation
    private var spendLabels : [String] {
        get {
            let spendValues = spendValuesBase.map {$0 * multiplier}
            return spendValues.map {String("\(currencySymbol)\($0)")}
        }
    }
    
    
    init(){
        //Bind changes in totalspending to update spentLabel
        //
        dataStore.todaysSpendingOutput.map{"Today I spent about: \(self.currencySymbol)\($0)"}.bind(to: spentLabelTextOutput).disposed(by: disposeBag)
        
        //
        //spentLabelSelectedInput.subscribe(onNext: {self.dataStore.addspend(thisSpend: self.spendValues[$0])}).disposed(by: disposeBag)
        spentLabelSelectedInput.map{self.spendValues[$0]}.bind(to: dataStore.newSpendInput).disposed(by: disposeBag)
        
    }
    
    func send() {
        
        dataStore.sendTodaysSpending()
        //dataStore.startAllSpending()
        
        //Display collection view of the spend options
        //
        Observable.just(spendLabels).bind(to: collectionViewArrayOutput).disposed(by: disposeBag)
    }
}

