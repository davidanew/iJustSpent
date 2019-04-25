//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import CoreData

class DataStore  {
    //Core data is retrieved into this array
    private var itemArray : [Item] = []
    //The total is associated with a date. Calender needed for these calculations
    private let calendar = Calendar.current
    //Context for core data
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Store total in observable so view can pick it up asynconously
    var totalSpendingOutput = BehaviorSubject<Int64>(value: 0)
    
    //TODO: This should throw if empty
    func addspend(thisSpend: Int64) {
        //Retrieve data into itemArray
        getData()
        //data should never be empty
        if !itemArray.isEmpty {
            //Add this spending
            itemArray[0].total += thisSpend
            //Send new total
            totalSpendingOutput.onNext(itemArray[0].total)
        }
        //Save new data back to core data
        saveData()
    }
    
    init() {
        //Retrieve data into itemArray
        getData()
        //data should never be empty
        if !itemArray.isEmpty {
            //Send the total spending
            totalSpendingOutput.onNext(itemArray[0].total)
        }
        else {
            print ("problem getting data on init")
        }
        
    }
    
    //TODO: look at error handling
    //TODO: This should throw
    //may need to be updated for other tab view
    //mabe this one should be get todays data
    //or get data passing in date
    private func getData() {
        //print("fetching items into array")
        //We need the time for today to index the spending
        //Use the start of the day
        let todayStartOfDay = calendar.startOfDay(for: Date())
        //We need to search the db for the current entry for today
        let todayStaryOfDayPredicate = NSPredicate(format: "date = %@", todayStartOfDay as NSDate)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = todayStaryOfDayPredicate
        
        do{
            //Try and retrieve data for today
            itemArray = try context.fetch(request)
            //print ("fetched array\(itemArray)")
            if itemArray.isEmpty {
                //If there is no data for today we need to create a new entry
                //print("array is empty")
                let newItem = Item(context: context )
                newItem.date = calendar.startOfDay(for: Date())
                newItem.total = 0
                itemArray.append(newItem)
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
