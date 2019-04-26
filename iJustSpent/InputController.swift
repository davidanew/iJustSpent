//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

class InputController {
    
    private let disposeBag = DisposeBag()
    //Output that sends text for the spending for today
    let spentLabelTextOutput  = PublishSubject<String>()
    //Output that sends label text for input collection view
    let collectionViewArrayOutput = PublishSubject<[String]>()
    //Input from view, event is the item number selected in collection view
    let spentLabelSelectedInput = PublishSubject<Int>()
    //The options for spending that are displayed and are clickable
    private let spendValuesBase : [TotalType] = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60,70,80,90,100]
    //TODO: Put these values in user defaults
    //TODO: Multiply spend options for different currency
    //Only Int supported at the moment
    private let multiplier : TotalType = 1
    private let currencySymbol : String = "£"
    //Handles storing and updating of the spending
    private let dataStore = DataStore()
    //Calculate spend options as a number
    private var spendValues : [TotalType] {
        return spendValuesBase.map {$0 * multiplier}
    }
    //spend options as string
    private var spendLabels : [String] {
        return spendValues.map {String("\(currencySymbol)\($0)")}
    }
    //Init used to set up bindings
    init(){
        //Send spend to datastore
        spentLabelSelectedInput.map{self.spendValues[$0]}.bind(to: dataStore.newSpendInput).disposed(by: disposeBag)
        //Bind changes in totalspending to update spentLabel
        dataStore.todaysSpendingOutput.map{"Today I spent about: \(self.currencySymbol)\($0)"}.bind(to: spentLabelTextOutput).disposed(by: disposeBag)
    }
    //Data requested
    func send() {
        //Request datastore to send todays spending
        dataStore.sendTodaysSpending()
        //Display collection view of the spend options
        Observable.just(spendLabels).bind(to: collectionViewArrayOutput).disposed(by: disposeBag)
    }
}

