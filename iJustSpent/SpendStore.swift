//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import CoreData
import os.log
//Type used by core data to save int values
typealias SpendIntType = Int16

//TODO: Document usage of this
struct SpendDateAndValue {
    let date : Date?
    let units : SpendIntType
    let subUnits : SpendIntType
}

class SpendStore  {
    private let disposeBag = DisposeBag()
    private let calendar = Calendar.current
    //
    let spendOutput = PublishSubject<[SpendDateAndValue]>()
    //Input for a new spend from input controller
    let newSpendInput = PublishSubject<SpendDateAndValue>()
    //init maps subscriptions
    init() {
        //When a new spend comes in we add this to the core data and send the new data back
        newSpendInput
            .subscribe(onNext : {[weak self] (newSpend : SpendDateAndValue) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            //Construct new object to store the new spend
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
            //Save to core data has been done, now get all the data to send back
            let request : NSFetchRequest<Spend> = Spend.fetchRequest()
            guard let updatedSpendArray = try? context.fetch(request) else {
                os_log("Context fetch error")
                return
            }
            self?.spendOutput.onNext(updatedSpendArray.map{ (spend : Spend) -> SpendDateAndValue in
                return SpendDateAndValue(date: spend.date, units: spend.units, subUnits: spend.subUnits)
            })
        } ).disposed(by: disposeBag)
    }
    //When Init has mapped the subcriptions, this is called to send new data
    //E.g on app initialisation or significant time change
    func send() {
        let thisContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request : NSFetchRequest<Spend> = Spend.fetchRequest()
        guard let spendArray = try? thisContext.fetch(request) else {
            os_log(" context fetch error")
            return
        }
        spendOutput.onNext(spendArray.map{ (spend : Spend) -> SpendDateAndValue in
            return SpendDateAndValue(date: spend.date, units: spend.units, subUnits: spend.subUnits)
        })
    }
}
