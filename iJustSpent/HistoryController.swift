//
//  HistoryContoller.swift
//  iJustSpent
//
//  Created by David New on 26/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct HistoryTableInput {
    var date : String
    var total : String
}

class HistoryController {
    
    //TODO user defaults
    private let currencySymbol : String = "£"

    
    private let disposeBag = DisposeBag()
    //Handles core data and adding new values
    private var dataStore = DataStore()
    //data that is sent back to the view
    let historyDataOutput = PublishSubject<[HistoryTableInput]>()
    //bind datastore output to the view
    init (){
        //TODO: function called dateAndTotalToHistoryTableInput
        dataStore.allSpendingOutput.map{(dataAndTotalArray : [DateAndTotal]) -> [HistoryTableInput] in
            return self.constructHistoryTableInput(dateAndTotalArray: dataAndTotalArray)
        }.bind(to: historyDataOutput).disposed(by: disposeBag)
    }
    
    func constructHistoryTableInput (dateAndTotalArray : [DateAndTotal]) -> [HistoryTableInput] {
        
        let dateAndTotalArraySorted = dateAndTotalArray.sorted(by: { (input1 : DateAndTotal, input2 :DateAndTotal) -> Bool in
            return (input1.date > input2.date)
        })
        let historyTableInputArray = dateAndTotalArraySorted.map{ (dateAndTotal : DateAndTotal) -> HistoryTableInput in
            HistoryTableInput(date: self.dateToText(dateAndTotal.date), total: "\(currencySymbol)\(dateAndTotal.total)")
        }
        return historyTableInputArray
    }
    
    func dateToText (_ date: Date) -> String {
        let weekDay = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
        let month = DateFormatter().monthSymbols[Calendar.current.component(.month, from: date)-1]
        let dayOfMonth = Calendar.current.component(.day, from: date)
        return ("\(weekDay) \(dayOfMonth) \(month)")
    }
    
    func send() {
        // request data from datastore
        dataStore.sendAllSpending()
    }
}
