
//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import CoreData


//class DataStore: DataStoreProtocol {

class DataStore  {
    
    var itemArray : [Item] = []
    let calendar = Calendar.current
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var totalSpending = BehaviorSubject<Int64>(value: 0)
    
    func addspend(thisSpend: Int64) {
        getData()
        if !itemArray.isEmpty {
            itemArray[0].total += thisSpend
            totalSpending.onNext(itemArray[0].total)
        }
        saveData()
        
        
        /*
        do {
            let total = try totalSpending.value()
            totalSpending.onNext(total + thisSpend)
            
        }
        catch {
            print ("error")
            return
        }
 */
        
    }
    
    init() {
        getData()
        if !itemArray.isEmpty {
            totalSpending.onNext(itemArray[0].total)
        }
        else {
            print ("problem getting data on init")
        }
        
    }
    
    //TODO: look at error handling
    func getData() {
        print("fetching items into array")
        let todayStartOfDay = calendar.startOfDay(for: Date())
        let todayStaryOfDayPredicate = NSPredicate(format: "date = %@", todayStartOfDay as NSDate)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = todayStaryOfDayPredicate
        
        do{
            itemArray = try context.fetch(request)
            print ("fetched array\(itemArray)")
            if itemArray.isEmpty {
                print("array is empty")
                let newItem = Item(context: context )
                newItem.date = calendar.startOfDay(for: Date())
                newItem.total = 0
                itemArray.append(newItem)
                print("added \(newItem)")
            }
            else {
                print ("array is not empty")
            }
        }
        catch{
            print ("context fetch error \(error)")
        }
        
        
        //return itemArray[0].total
    }
    
    func saveData () {
        print("save new value")
        do {
            try context.save()
        }
        catch {
            print ("context save error \(error)")
        }
    }
    



   /*
    
    
     var itemArray : [Item] = []
     // var total : Int64 = 0
     
     let calendar = Calendar.current
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
     print("fetching items into array")
     let todayStartOfDay = calendar.startOfDay(for: Date())
     let todayStaryOfDayPredicate = NSPredicate(format: "date = %@", todayStartOfDay as NSDate)
     
     let request : NSFetchRequest<Item> = Item.fetchRequest()
     request.predicate = todayStaryOfDayPredicate
     
     do{
     itemArray = try context.fetch(request)
     }
     catch{
     print ("context fetch error \(error)")
     return
     }
     
     print ("fetched array\(itemArray)")
     
     if itemArray.isEmpty {
     print("array is empty")
     let newItem = Item(context: context )
     newItem.date = calendar.startOfDay(for: Date())
     newItem.total = 0
     itemArray.append(newItem)
     print("added \(newItem)")
     }
     else {
     print ("array is not empty")
     }
     
     
     
     print("current total \(itemArray[0].total)")
     
     
     
     print("increment item")
     itemArray[0].total += Int64(thisSpend)
     
     print("new total \(itemArray[0].total)")
     
     
     print("save new value")
     
     do {
     try context.save()
     }
     catch {
     print ("context save error \(error)")
     }
     
     totalSpending = Int(itemArray[0].total)
     //        lastSpend = thisSpend
     //print(totalSpending)
     
     spentLabel.text = spentLabelText
  */
    
}
