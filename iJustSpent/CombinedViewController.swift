//
//  combinedViewController.swift
//  iJustSpent
//
//  Created by David New on 06/05/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import os.log

class CombinedViewController: UIViewController {
 //   @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var entryPicker1: UIPickerView!
    @IBOutlet weak var entryPicker2: UIPickerView!
    @IBOutlet weak var entryPicker3: UIPickerView!
    @IBOutlet weak var entryPicker4: UIPickerView!
    @IBOutlet weak var entryPicker5: UIPickerView!
    @IBOutlet weak var entryPicker6: UIPickerView!
    @IBOutlet weak var entryPicker7: UIPickerView!
    @IBOutlet weak var botButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    
    let disposeBag = DisposeBag()
    //let controller = HistoryController()
    let spendStore = SpendStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segControl.backgroundColor = .clear
        segControl.tintColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        botButton.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        botButton.layer.cornerRadius = 5
        botButton.setTitleColor(UIColor.black, for:UIControlState.normal)
        let pickerInput = ["0","1","2","3","4","5","6","7","8","9"]
        Observable.just([["£"]])
            .bind(to: entryPicker1.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([pickerInput])
            .bind(to: entryPicker2.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([Array(0...9).map{"\($0)"}])
            .bind(to: entryPicker3.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([Array(0...9).map{"\($0)"}])
            .bind(to: entryPicker4.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([[":"]])
            .bind(to: entryPicker5.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([Array(0...9).map{"\($0)"}])
            .bind(to: entryPicker6.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([Array(0...9).map{"\($0)"}])
            .bind(to: entryPicker7.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        spendStore.spendOutput.map { spendDateAndValueArray  in
            return GetTotalByDayForTableView.getTotalByDayForTableView(spendDateAndValueArray: spendDateAndValueArray )
        }.bind(to: historyTableView.rx.items(cellIdentifier: "CombinedCell", cellType: CombinedTableViewCell.self)) { row, model, cell in
            cell.date.text = "\(model.date)"
            cell.spending.text = "\(model.total)"
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            //cell.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)

            cell.tintColor = UIColor.black
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
            }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Ask controller to send data
        spendStore.send()
    }
}


//TODO: rename and put in another file
class GetTotalByDayForTableView {
    
    
    //TODO user defaults
   // private let currencySymbol : String = "£"

    struct DayHistoryTableInput {
        var date : String
        var total : String
    }
    
    private static func dateToText (_ date: Date) -> String {
        let weekDay = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
        let month = DateFormatter().monthSymbols[Calendar.current.component(.month, from: date)-1]
        let dayOfMonth = Calendar.current.component(.day, from: date)
        return ("\(weekDay) \(dayOfMonth) \(month)")
    }
    
    static func getTotalByDayForTableView (spendDateAndValueArray : [SpendDateAndValue]) -> [DayHistoryTableInput] {
        struct UnitsAndSubunits {
            var units : SpendIntType
            var subUnits : SpendIntType
        }
        var dayDictionary : Dictionary<Date, UnitsAndSubunits> = [:]
        
        spendDateAndValueArray.forEach { (spendDateAndValue) in
            guard let thisDate = spendDateAndValue.date else {
                os_log("date is nil")
                return
            }
            let thisStartOfDay = Calendar.current.startOfDay(for: thisDate)
            print(spendDateAndValue)
            if dayDictionary[thisStartOfDay] == nil {
                dayDictionary[thisStartOfDay] = UnitsAndSubunits(units: spendDateAndValue.units, subUnits: spendDateAndValue.subUnits)
                print("adding new entry")
            }
            else {
                print("amending entry")
                let subUnitsSum = (dayDictionary[thisStartOfDay]?.subUnits ?? 999) + spendDateAndValue.subUnits
                let subUnitsMod = subUnitsSum % 100
                let subUnitsCarry = SpendIntType((subUnitsSum-subUnitsMod)/100)
                let unitsSum = (dayDictionary[thisStartOfDay]?.units ?? 999) + spendDateAndValue.units + subUnitsCarry
                
               // print ("subUnitsSum \(subUnitsSum) = \(dayDictionary[thisStartOfDay]?.subUnits ?? 999) + \(spendDateAndValue.subUnits)")

                print ("units sum \(unitsSum)")
                print ("subUnitsMod \(subUnitsMod)")
                dayDictionary[thisStartOfDay]?.units = unitsSum
                dayDictionary[thisStartOfDay]?.subUnits = subUnitsMod
            }
        }
        var totalByDay : [DayHistoryTableInput] = []
        // now need to produce structure for table UIView
        dayDictionary.forEach { (key: Date, value: UnitsAndSubunits) in
            
            //todo sort out symbol
            totalByDay.append(DayHistoryTableInput(date: dateToText(key), total: "£\(value.units):\(String(format: "%02d", value.subUnits ))"  ))
            
            
            
            //   totalByDay.append(SpendDateAndValue(date: key, units: value.units, subUnits: value.subUnits))
        }
        return totalByDay
    }
    
    
    
}
