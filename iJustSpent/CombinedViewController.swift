//  Copyright © 2019 David New. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import os.log

//TODO: make sure no overflow

class CombinedViewController: UIViewController {
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
    let spendStore = SpendStore()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grayColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        let yellowColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        //segControl.backgroundColor = .clear
        //segControl.tintColor = yellowColor
        botButton.backgroundColor = yellowColor
        botButton.layer.cornerRadius = 5
        botButton.setTitleColor(UIColor.black, for:UIControlState.normal)
        
        setupPickerViews()

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
        
        struct DayHistoryTableInput {
            var date : String
            var total : String
        }
        
        enum TableviewUpdateEvent {
            case spendOutput
            case entryButtonDown
            case entryButtonUp
        }

        spendStore.spendOutput.map { spendDateAndValueArray  in
            return TableUtils.getTotalByDayForTableView(spendDateAndValueArray: spendDateAndValueArray )
            }
            .bind(to: historyTableView.rx.items(cellIdentifier: "CombinedCell", cellType: CombinedTableViewCell.self)) { row, model, cell in
                cell.date.text = "\(model.date)"
                cell.spending.text = "\(model.total)"
                cell.layer.cornerRadius = 5
                cell.layer.masksToBounds = true
                cell.backgroundColor = grayColor
                cell.tintColor = UIColor.black
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.black.cgColor
                if model.date == "Today" {
                    cell.backgroundColor = yellowColor
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
