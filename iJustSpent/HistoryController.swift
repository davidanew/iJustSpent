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
    private var dataStore = DataStore()
    let historyDataOutput = PublishSubject<[DateAndTotal]>()
    
    init (){
        dataStore.allSpendingOutput.bind(to: historyDataOutput).disposed(by: disposeBag)
    }
    
    func send() {
        dataStore.sendAllSpending()
    }
    
    
    
}
