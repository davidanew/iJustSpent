//  Copyright © 2019 David New. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import os.log

//TODO: GUI tests
//TODO: Try accessability
//TODO: Try diffrent devices/orientationse
//TODO: what is have over a year of data? can uninstall or have limit on number of items, or max one year. ITHINKMAX ENTRIES BEST, remove oldest 100 entries
//TODO: App icon and start screen
//TODO: User tests
//TODO: only release limited regions

//Possible paid-for feature, detail table view spend removal
//Max mem about 53.7 MB
//Possible future - dialog box to indicate > 100 items deleted

class CombinedViewController: UIViewController {
    //For spending value entry
    //Displays the currency symbols
    @IBOutlet weak var entryPicker1: UIPickerView!
    //Three digits for pounds (or equivalent)
    @IBOutlet weak var entryPicker2: UIPickerView!
    @IBOutlet weak var entryPicker3: UIPickerView!
    @IBOutlet weak var entryPicker4: UIPickerView!
    //Currently this shows a colon
    @IBOutlet weak var entryPicker5: UIPickerView!
    //Pence entry (or equivalent
    @IBOutlet weak var entryPicker6: UIPickerView!
    @IBOutlet weak var entryPicker7: UIPickerView!
    //Add spend button
    @IBOutlet weak var addButton: UIButton!
    //Undo button
    @IBOutlet weak var undoButton: UIButton!
    //Table view of daily spend
    @IBOutlet weak var historyTableView: UITableView!
    //For rxswift
    let disposeBag = DisposeBag()
    //Handles Core Data operations
    let spendStore = SpendStore()
    

    //Make the text in the title bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.accessibilityIdentifier = "tableView"
        //historyTableView.accessibilityLabel = "tableView"

        let currencySymbol = NumberFormatter().currencySymbol ?? "$"
        let grayColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        let yellowColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        undoButton.layer.cornerRadius = 5
        addButton.layer.cornerRadius = 5
        setupPickerViews(currencySymbol: currencySymbol)
        //Undo button removes last entry if there is one
        undoButton.rx.tap.bind(to: spendStore.undoInput).disposed(by: disposeBag)
        //Highlight button on tap
        undoButton.rx.tap.map{_ in return grayColor}.bind(to: undoButton.rx.backgroundColor).disposed(by: disposeBag)
        //Remove highlight after delay
        undoButton.rx.tap.delay(.milliseconds(300), scheduler: MainScheduler.instance).map{_ in return yellowColor}.bind(to: undoButton.rx.backgroundColor).disposed(by: disposeBag)
        //On add button tap calculate the amount spent and send this information to spendStore
        addButton.rx.tap.map { [weak self] _ -> SpendDateAndValue in
            let unitsCombined = SpendIntType(self?.entryPicker2.selectedRow(inComponent: 0) ?? 0) * 100 +
                SpendIntType(self?.entryPicker3.selectedRow(inComponent: 0) ?? 0) * 10 +
                SpendIntType(self?.entryPicker4.selectedRow(inComponent: 0) ?? 0)
            let subUnitsCombined = SpendIntType(self?.entryPicker6.selectedRow(inComponent: 0) ?? 0) * 10 +
                SpendIntType(self?.entryPicker7.selectedRow(inComponent: 0) ?? 0)
            return SpendDateAndValue(date: Date(), units: unitsCombined, subUnits: subUnitsCombined)
            }
            //We don't want to send nil data
            .filter{$0.units > 0 || $0.subUnits > 0}
            //Send to spend store input
            .bind(to: spendStore.newSpendInput).disposed(by: disposeBag)
        //Highlight add button on tap
        addButton.rx.tap.map{_ in return grayColor}.bind(to: addButton.rx.backgroundColor).disposed(by: disposeBag)
        //Remove add button highlight after delay
        addButton.rx.tap.delay(.milliseconds(300), scheduler: MainScheduler.instance).map{_ in return yellowColor}.bind(to: addButton.rx.backgroundColor).disposed(by: disposeBag)
        //Clear picker on button tap
        addButton.rx.tap.subscribe(onNext:{[weak self] _ in
            self?.entryPicker2.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker3.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker4.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker6.selectRow(0, inComponent: 0, animated: true)
            self?.entryPicker7.selectRow(0, inComponent: 0, animated: true)
        }).disposed(by: disposeBag)
        //scroll to top of tableview on tap
        addButton.rx.tap.subscribe(onNext: {[weak self] _ in self?.historyTableView.scrollToRow(at:IndexPath(row: 0, section: 0) , at: .top, animated: true)}).disposed(by: disposeBag)
        //When spendStore sends an update of it's stored data
        //Send this to the tableview
        spendStore.spendOutput.map { spendDateAndValueArray  in
            return TableUtils.getTotalByDayForTableView(spendDateAndValueArray: spendDateAndValueArray )
            }
            .bind(to: historyTableView.rx.items(cellIdentifier: "CombinedCell", cellType: CombinedTableViewCell.self)) { row, model, cell in
                cell.accessibilityIdentifier = "cell_\(row)"
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
    
    func setupPickerViews(currencySymbol : String) {
        let pickerInput = ["0","1","2","3","4","5","6","7","8","9"]
        Observable.just([[currencySymbol]])
            .bind(to: entryPicker1.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        entryPicker1.isUserInteractionEnabled = false
        Observable.just([pickerInput])
            .bind(to: entryPicker2.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([pickerInput])
            .bind(to: entryPicker3.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([pickerInput])
            .bind(to: entryPicker4.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([[":"]])
            .bind(to: entryPicker5.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        entryPicker5.isUserInteractionEnabled = false
        Observable.just([pickerInput])
            .bind(to: entryPicker6.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        Observable.just([pickerInput])
            .bind(to: entryPicker7.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
        //We needs to be able to identify picker in picker view
        entryPicker1.tag = 1
        entryPicker2.tag = 2
        entryPicker3.tag = 3
        entryPicker4.tag = 4
        entryPicker5.tag = 5
        entryPicker6.tag = 6
        entryPicker7.tag = 7
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Ask spendStore to send initial data
        spendStore.send()
    }
}
