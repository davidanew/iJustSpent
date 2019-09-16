//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import CoreData
import os.log
//Type used by core data to save int values
typealias SpendIntType = Int32

//This is the structure used to input and output data
//The input will be a single instance
//The output is an array of all the transactions
struct SpendDateAndValue {
    let date : Date?
    let units : SpendIntType
    let subUnits : SpendIntType
}

class SpendStore  {
    //For rxswift
    private let disposeBag = DisposeBag()
    private let calendar = Calendar.current
    //Output to view controller, contains all spending data as array
    let spendOutput = PublishSubject<[SpendDateAndValue]>()
    //Input for a new spend from input controller
    let newSpendInput = PublishSubject<SpendDateAndValue>()
    //For when undo button pressed (no data)
    let undoInput = PublishSubject<Void>()
    //init maps subscriptions but does not send data
    init() {
        //When a new spend comes in we add this to the core data and send the new data back
        newSpendInput
        .subscribe(onNext : {[weak self] (newSpend : SpendDateAndValue) in
            //Core data context
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
            //Save of new item to core data has been done, now get all the data to send back
            let request : NSFetchRequest<Spend> = Spend.fetchRequest()
            guard let updatedSpendArray = try? context.fetch(request) else {
                os_log("Context fetch error")
                return
            }
            //Send the data via spendOutput
            self?.spendOutput.onNext(updatedSpendArray.map{ (spend : Spend) -> SpendDateAndValue in
                return SpendDateAndValue(date: spend.date, units: spend.units, subUnits: spend.subUnits)
            })
        } ).disposed(by: disposeBag)
        
        undoInput
        .subscribe(onNext : {[weak self] _ in
            //Core Data setup request to get latest item from core data
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let requestLatest : NSFetchRequest<Spend> = Spend.fetchRequest()
            requestLatest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            requestLatest.fetchLimit = 1
            //Try and get item
            guard let latestItem = try? context.fetch(requestLatest) else {
                return //this is not an error as list may be empty
            }
            //The above will get an array, we need to work on the individual item
            //TODO: flatmap/map experiment (optional)
            for object in latestItem {
                context.delete(object)
            }
            do{
                try context.save()
            }
            catch {
                os_log("New item context save error")
                return
            }
            //Save to core data has been done, now get all the data to send back
            //This is the same as in newSpendInput so could be a subroutine
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
    //E.g on app initialisation or significant time change or when new data has been added
    func send() {
        //Core data setup
        let thisContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //This could be subroutine with the above code, maybe send in context?
        let request : NSFetchRequest<Spend> = Spend.fetchRequest()
        //Try and get the data to send
        guard let spendArray = try? thisContext.fetch(request) else {
            os_log(" context fetch error")
            return
        }
        //Send the data via spendOutput
        spendOutput.onNext(spendArray.map{ (spend : Spend) -> SpendDateAndValue in
            return SpendDateAndValue(date: spend.date, units: spend.units, subUnits: spend.subUnits)
        })
    }
}
