//
//  ViewController.swift
//  iJustSpent
//
//  Created by David New on 09/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit
import CoreData

class InputView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var spentLabel: UILabel!
    var totalSpending : Int = 0
//    var lastSpend : Int = 0
    let spendValuesBase : [Int] = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60,70,80,90,100]
    let multiplier : Int = 1
    let currencySymbol : String = "£"
    var spendValues : [Int] {
        get {
            return spendValuesBase.map {$0 * multiplier}
        }
    }
    var spendLabels : [String] {
        get {
            return spendValues.map {String("\(currencySymbol)\($0)")}
        }
    }
    var spentLabelText : String {
        get {
            return ("Today I spent about: \(currencySymbol)\(totalSpending)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spendLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: !
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InputCell
        cell.label.text = spendLabels[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyCell
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell?.backgroundColor = UIColor.red

        }
        let thisSpend = spendValues[indexPath.item]
       
        
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
        
    }
}



