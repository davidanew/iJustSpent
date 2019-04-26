//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import CoreData
import os.log


struct DateAndTotal {
    var date: Date
    var total: Int64
}

class DataStore  {
    
    private let disposeBag = DisposeBag()
    //Core data is retrieved into this array
    private var itemArrayToday : [Item] = []
    private var itemArrayAll : [Item] = []
    //The total is associated with a date. Calender needed for these calculations
    private let calendar = Calendar.current
    //Context for core data
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Store total in observable so view can pick it up asynconously
    //TODO: change Int64 to custom type
    let todaysSpendingOutput = PublishSubject<Int64>()
    let allSpendingOutput = PublishSubject<[DateAndTotal]>()
    let newSpendInput = PublishSubject<Int64>()
    
    //init subscribes inputs
    init() {
        //Subscibe to new spending events
        //TODO: error handling
        newSpendInput.subscribe(onNext: {thisSpend in
            //Retrieve data into itemArray
            self.getTodaysData(coredDataObject: &self.itemArrayToday)
            
            //data should never be empty
            if !self.itemArrayToday.isEmpty {
                //Add this spending
                self.itemArrayToday[0].total += thisSpend
                //Send new total
                self.todaysSpendingOutput.onNext(self.itemArrayToday[0].total)
            }
            //Save new data back to core data
            self.saveData()
            //getDataAll()
        }).disposed(by: disposeBag)
    }
    
 
    //could be a trigger
    func sendTodaysSpending() {
        //Retrieve data into itemArray
        getTodaysData(coredDataObject: &itemArrayToday)
        //data should never be empty
        if !itemArrayToday.isEmpty {
            //Send the total spending
            todaysSpendingOutput.onNext(itemArrayToday[0].total)
        }
        else {
            os_log("startTodaysSpending error")
        }

    }
    
    func sendAllSpending() {
        getAllData(coredDataObject: &itemArrayAll)
        allSpendingOutput.onNext(itemArrayAll.map{item in return DateAndTotal(date : item.date ?? Date() , total : item.total )   })
        //Todo also need non-startup events
    }
    
    //TODO: look at error handling
    //TODO: This should throw
    private func getTodaysData(coredDataObject: inout [Item]) {
        //print("fetching items into array")
        //We need the time for today to index the spending
        //Use the start of the day
        var searchPredicate: NSPredicate?
        let todayStartOfDay = calendar.startOfDay(for: Date())
        //We need to search the db for the current entry for today
        searchPredicate = NSPredicate(format: "date = %@", todayStartOfDay as NSDate)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = searchPredicate
        
        do{
            ////Try and retrieve data for today
            coredDataObject = try context.fetch(request)
            //print ("fetched array\(itemArray)")
            if coredDataObject.isEmpty {
                //If there is no data for today we need to create a new entry
                //print("array is empty")
                //TODO: may not be the case if not todayonly
                let newItem = Item(context: context )
                newItem.date = calendar.startOfDay(for: Date())
                newItem.total = 0
                coredDataObject.append(newItem)
                //print("added \(newItem)")
            }
            else {
                // array is not empty, dont need to do anything
                //TODO: Maybe remove this else section
                //print ("array is not empty, dont need to do anything")
            }
        }
        catch{
            //print ("context fetch error \(error)")
        }
    }
    
    private func getAllData(coredDataObject: inout [Item]) {

        //
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //
        do{
            coredDataObject = try context.fetch(request)
        }
        catch{
            //print ("context fetch error \(error)")
        }
    }
    

    //TODO: This should throw
    private func saveData () {
        //print("save new value")
        do {
            // save data in itemArray
            try context.save()
        }
        catch {
            print ("context save error \(error)")
        }
    }
}
