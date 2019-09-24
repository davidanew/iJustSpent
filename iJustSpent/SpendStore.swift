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
            //Remove old entries if we reach a certain limit
            self?.limitEntries(context: context)
            //Send all core data via spendOutput
            self?.sendAllData(context: context)
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
            self?.sendAllData(context: context)
        } ).disposed(by: disposeBag)
    }
    //When Init has mapped the subcriptions, this is called to send new data
    //E.g on app initialisation or significant time change or when new data has been added
    func send() {
        //Core data setup
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        sendAllData(context: context)

    }
    
    func sendAllData(context : NSManagedObjectContext){
        //Get all the data to send back
        let request : NSFetchRequest<Spend> = Spend.fetchRequest()
        guard let updatedSpendArray = try? context.fetch(request) else {
            os_log("Context fetch error")
            return
        }
        //Send the data via spendOutput
        self.spendOutput.onNext(updatedSpendArray.map{ (spend : Spend) -> SpendDateAndValue in
            return SpendDateAndValue(date: spend.date, units: spend.units, subUnits: spend.subUnits)
        })
        
    }
    
    //This function removes the oldest data if the entry count goes above 100
    func limitEntries(context : NSManagedObjectContext){
        let request : NSFetchRequest<Spend> = Spend.fetchRequest()
        if let count = try? context.count(for: request){
            //print(count)
            //if more than 100 enties we want to delete the oldest
            if count > 100 {
                let requestLatest : NSFetchRequest<Spend> = Spend.fetchRequest()
                //Gets last entry
                requestLatest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                requestLatest.fetchLimit = 1
                //Try and get item
                guard let latestItem = try? context.fetch(requestLatest) else {
                    return //this is not an error as list may be empty
                }
                //Delete object
                for object in latestItem {
                    context.delete(object)
                }
            }
        }
    }
}
