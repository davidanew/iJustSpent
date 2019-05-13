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
    
    /*
    class EntryPickers {
        static let picker1 : inout UISegmentedControl
        
    }
 */
 
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let grayColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        let yellowColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        segControl.backgroundColor = .clear
        segControl.tintColor = yellowColor
        botButton.backgroundColor = yellowColor
        botButton.layer.cornerRadius = 5
        botButton.setTitleColor(UIColor.black, for:UIControlState.normal)
        
        setupPickerViews()
        
        //TODO: map tap to history view entry
        
        
        
        botButton.rx.tap.map { [weak self] _ -> SpendDateAndValue in
            let unitsCombined = SpendIntType(self?.entryPicker2.selectedRow(inComponent: 0) ?? 0) * 100 +
                SpendIntType(self?.entryPicker3.selectedRow(inComponent: 0) ?? 0) * 10 +
                SpendIntType(self?.entryPicker4.selectedRow(inComponent: 0) ?? 0)
            let subUnitsCombined = SpendIntType(self?.entryPicker6.selectedRow(inComponent: 0) ?? 0) * 10 +
                SpendIntType(self?.entryPicker7.selectedRow(inComponent: 0) ?? 0)
            return SpendDateAndValue(date: Date(), units: unitsCombined, subUnits: subUnitsCombined)
            }.filter{$0.units > 0 || $0.subUnits > 0}
            .bind(to: spendStore.newSpendInput).disposed(by: disposeBag)
        
        botButton.rx.tap.map{_ in return grayColor}.bind(to: botButton.rx.backgroundColor).disposed(by: disposeBag)
        botButton.rx.tap.delay(0.3, scheduler: MainScheduler.instance).map{_ in return yellowColor}.bind(to: botButton.rx.backgroundColor).disposed(by: disposeBag)
        botButton.rx.tap.subscribe(onNext:{[weak self] _ in
            self?.entryPicker2.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker3.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker4.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker6.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker7.selectRow(0, inComponent: 0, animated: true)
        }).disposed(by: disposeBag)
        
        /*
        botButton.rx.tap.map { _  in
            return []
            }.bind(to: historyTableView.rx.items(cellIdentifier: "CombinedCell", cellType: CombinedTableViewCell.self)) { row, model, cell in
                cell.backgroundColor = UIColor.red
            }.disposed(by: disposeBag)
        */
        
        //TODO need to merge to get this to work maybe
        
        /*
        
        Observable.combineLatest(
            spendStore.spendOutput,
                                 botButton.rx.tap,
                                 botButton.rx.tap.delay(0.3, scheduler: MainScheduler.instance))
        {(value1 : () ,value2,value3) in
            return nil
            
        }
        */
        
        struct DayHistoryTableInput {
            var date : String
            var total : String
        }
        
        enum TableviewUpdateEvent {
            case spendOutput
            case entryButtonDown
            case entryButtonUp
        }
        
        
        //let x = TableviewUpdateEvent.spendOutput
        
        
        let delme = Observable.combineLatest(spendStore.spendOutput,
                                 spendStore.spendOutput.map{_ in return TableviewUpdateEvent.spendOutput},
                                 botButton.rx.tap.map{_ in return TableviewUpdateEvent.entryButtonDown},
                                 botButton.rx.tap.delay(0.3, scheduler: MainScheduler.instance).map{_ in return TableviewUpdateEvent.entryButtonUp},
                                 
                                 resultSelector: { (spendOutput : [SpendDateAndValue] ,  spendOutputEvent  , buttonDownEvent, buttonUpEvent) -> [SpendDateAndValue]  in
                                    return spendOutput
                                    
        })
        
        _ = delme
        
        

        
        
        
   
        
        spendStore.spendOutput.map { spendDateAndValueArray  in
       //     print ("spendOutput")
            return GetTotalByDayForTableView.getTotalByDayForTableView(spendDateAndValueArray: spendDateAndValueArray )
        }.debug()
            .bind(to: historyTableView.rx.items(cellIdentifier: "CombinedCell", cellType: CombinedTableViewCell.self)) { row, model, cell in
            cell.date.text = "\(model.date)"
            cell.spending.text = "\(model.total)"
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            //cell.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
            cell.backgroundColor = grayColor

            cell.tintColor = UIColor.black
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
            
            
            if row == 0 {
                cell.backgroundColor = yellowColor
             //   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
             //       cell.backgroundColor = tableviewBackgroundColor
             //   }
            }
            
            }.disposed(by: disposeBag)
        
        
        
    }
    
    func setupPickerViews() {
        
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
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Ask controller to send data
        spendStore.send()
    }
}




//TODO: rename and put in another file
class GetTotalByDayForTableView {
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
    //todo needs to retunr today,yesterday etc
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
       //     print(spendDateAndValue)
            if dayDictionary[thisStartOfDay] == nil {
                dayDictionary[thisStartOfDay] = UnitsAndSubunits(units: spendDateAndValue.units, subUnits: spendDateAndValue.subUnits)
        //        print("adding new entry")
            }
            else {
       //         print("amending entry")
                let subUnitsSum = (dayDictionary[thisStartOfDay]?.subUnits ?? 999) + spendDateAndValue.subUnits
                let subUnitsMod = subUnitsSum % 100
                let subUnitsCarry = SpendIntType((subUnitsSum-subUnitsMod)/100)
                let unitsSum = (dayDictionary[thisStartOfDay]?.units ?? 999) + spendDateAndValue.units + subUnitsCarry
       //         print ("units sum \(unitsSum)")
       //         print ("subUnitsMod \(subUnitsMod)")
                dayDictionary[thisStartOfDay]?.units = unitsSum
                dayDictionary[thisStartOfDay]?.subUnits = subUnitsMod
            }
        }
        var totalByDay : [DayHistoryTableInput] = []
        // now need to produce structure for table UIView
        dayDictionary.forEach { (key: Date, value: UnitsAndSubunits) in
            //todo sort out symbol
            totalByDay.append(DayHistoryTableInput(date: dateToText(key), total: "£\(value.units):\(String(format: "%02d", value.subUnits ))"  ))
            }
        totalByDay.sort(by: { (input1: DayHistoryTableInput, input2: DayHistoryTableInput ) -> Bool in
            return (input1.date < input2.date)
        })
        return totalByDay
    }
}
