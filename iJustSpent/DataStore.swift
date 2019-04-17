//
//  DataStore.swift
//  iJustSpent
//
//  Created by David New on 16/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import Foundation


class DataStore: DataStoreProtocol {
    
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
