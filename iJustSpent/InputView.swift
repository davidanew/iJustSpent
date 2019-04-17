//
//  ViewController.swift
//  iJustSpent
//
//  Created by David New on 09/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa


protocol DataStoreProtocol {
    /*
    var spending: Int { get }
    func addSpend (spend: Int)
 */
}

class InputView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var spentLabel: UILabel!
//    var totalSpending = PublishSubject<String>()
    var totalSpending = BehaviorSubject<String>(value: "zero")
    //var buttonPushedSubject = PublishSubject<Int>()

    
//    var lastSpend : Int = 0
    let spendValuesBase : [Int] = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60,70,80,90,100]
    //TODO: Put these values in user defaults
    let multiplier : Int = 1
    let currencySymbol : String = "£"
    
    
    let dataStore = DataStore() as DataStoreProtocol
    
    
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
            
            //totalSpending = dataStore.spending
            return ("Today I spent about: \(currencySymbol)\(totalSpending)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //set label to current total
        //spentLabel.text = spentLabelText
        _ = totalSpending.bind(to: spentLabel.rx.text)
        //buttonPushedSubject.onNext(1)
        totalSpending.onNext("one")
        totalSpending.onNext("two")

        
        do {
            let x = try totalSpending.value()
            print (x)


        }
        catch {
            print ("error")
            return
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spendLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: look at !
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
        _ = thisSpend
       
        
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
 
        /*
        dataStore.addSpend(spend: thisSpend)
        spentLabel.text = spentLabelText
 */
        

 
 
 
    }
}



