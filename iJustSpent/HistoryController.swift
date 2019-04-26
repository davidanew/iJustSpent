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

class HistoryController {
    private let disposeBag = DisposeBag()
    //Handles core data and adding new values
    private var dataStore = DataStore()
    //data that is sent back to the view
    let historyDataOutput = PublishSubject<[DateAndTotal]>()
    //bind datastore output to the view
    init (){
        dataStore.allSpendingOutput.bind(to: historyDataOutput).disposed(by: disposeBag)
    }
    func send() {
        // request data from datastore
        dataStore.sendAllSpending()
    }
}
