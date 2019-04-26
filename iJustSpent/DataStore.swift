//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import CoreData
import os.log


struct DateAndTotal {
    var date: Date
    var total: TotalType
}

typealias TotalType = Int64

class DataStore  {
    private let disposeBag = DisposeBag()
    //Core data is retrieved into this array for todays spending
    private var itemArrayToday : [Item] = []
    //Core data for all spending
    private var itemArrayAll : [Item] = []
    //The total is associated with a date. Calender needed for these calculations
    private let calendar = Calendar.current
    //Context for core data
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Store total in observable so view can pick it up asynconously
    //Output for spending for today, used for input controller
    let todaysSpendingOutput = PublishSubject<TotalType>()
    //Output for all spending, used for history contoller
    let allSpendingOutput = PublishSubject<[DateAndTotal]>()
    //Input for a new spend from input controller
    let newSpendInput = PublishSubject<TotalType>()
    //init maps subscriptions
    init() {
        //Subscibe to new spending events
        newSpendInput.subscribe(onNext: {thisSpend in
            //Retrieve data into itemArray
            do {
                try self.getTodaysData(coredDataObject: &self.itemArrayToday)
                //data should never be empty
                if !self.itemArrayToday.isEmpty {
                    //Add this spending
                    self.itemArrayToday[0].total += thisSpend
                    //Send new total
                    self.todaysSpendingOutput.onNext(self.itemArrayToday[0].total)
                }
                //Save new data back to core data
                try self.saveData()
            }
            catch {
                os_log("init failed")
            }
        }).disposed(by: disposeBag)
    }
    //Called when input view needs update
    func sendTodaysSpending() {
        do {
            //Retrieve data into itemArray
            try getTodaysData(coredDataObject: &itemArrayToday)
            //data should never be empty
            if !itemArrayToday.isEmpty {
                //Send the total spending
                todaysSpendingOutput.onNext(itemArrayToday[0].total)
            }
            else {
                os_log("startTodaysSpending error")
            }
        }
        catch {
            os_log("sendTodaysSpending failed")
        }
    }
    //Called when history view needs update
    func sendAllSpending() {
        do {
            //retrieve data for all entries
            try getAllData(coredDataObject: &itemArrayAll)
            //send this data to contoller
            allSpendingOutput.onNext(itemArrayAll.map{item in return DateAndTotal(date : item.date ?? Date() , total : item.total )   })
        }
        catch
        {
            os_log("sendAllSpending failed")
        }
    }
    
    private func getTodaysData(coredDataObject: inout [Item]) throws {
        //We need the time for today to index the spending
        //Use the start of the day
        var searchPredicate: NSPredicate?
        let todayStartOfDay = calendar.startOfDay(for: Date())
        //We need to search the db for the current entry for today
        searchPredicate = NSPredicate(format: "date = %@", todayStartOfDay as NSDate)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = searchPredicate
        do{
            //Try and retrieve data for today
            coredDataObject = try context.fetch(request)
            if coredDataObject.isEmpty {
                //If there is no data for today we need to create a new entry
                let newItem = Item(context: context )
                newItem.date = calendar.startOfDay(for: Date())
                newItem.total = 0
                coredDataObject.append(newItem)
            }
        }
        catch{
            throw GenericError.description(text: "getTodaysData context fetch error: \(error.localizedDescription) ")
        }
    }
    
    //Get all the total spending for all days
    private func getAllData(coredDataObject: inout [Item]) throws {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            coredDataObject = try context.fetch(request)
        }
        catch{
            throw GenericError.description(text: "getAllData context fetch error: \(error.localizedDescription) ")
        }
    }
    
    private func saveData() throws {
        do {
            // save data in itemArray
            try context.save()
        }
        catch {
            throw GenericError.description(text: "saveData context save error: \(error.localizedDescription) ")
        }
    }
}
