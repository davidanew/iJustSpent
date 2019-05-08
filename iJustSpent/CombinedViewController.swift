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
    
    let controller = HistoryController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //topButton.
        
        segControl.backgroundColor = .clear
        segControl.tintColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        
    //   botButton.backgroundColor = .clear
        botButton.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        // topButton.layer.cornerRadius = 5
        botButton.layer.cornerRadius = 5

//        botButton.layer.borderWidth = 2
//        botButton.layer.borderColor = UIColor.red.cgColor
        
        botButton.setTitleColor(UIColor.black, for:UIControlState.normal)
        
        
        
        
        
    /*
        
        entryPicker2.layer.borderColor = UIColor.darkGray.cgColor
        entryPicker2.layer.borderWidth = 1.0
        entryPicker2.layer.cornerRadius = 7.0
        entryPicker2.layer.masksToBounds = true
        
        entryPicker3.layer.borderColor = UIColor.darkGray.cgColor
        entryPicker3.layer.borderWidth = 1.0
        entryPicker3.layer.cornerRadius = 7.0
        entryPicker3.layer.masksToBounds = true
        
        entryPicker4.layer.borderColor = UIColor.darkGray.cgColor
        entryPicker4.layer.borderWidth = 1.0
        entryPicker4.layer.cornerRadius = 7.0
        entryPicker4.layer.masksToBounds = true
        
        entryPicker6.layer.borderColor = UIColor.darkGray.cgColor
        entryPicker6.layer.borderWidth = 1.0
        entryPicker6.layer.cornerRadius = 7.0
        entryPicker6.layer.masksToBounds = true
        
        entryPicker7.layer.borderColor = UIColor.darkGray.cgColor
        entryPicker7.layer.borderWidth = 1.0
        entryPicker7.layer.cornerRadius = 7.0
        entryPicker7.layer.masksToBounds = true
        
        */
        
        

        
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
        
        
        
        /*
        
        Observable.just([Array(0...9).map{"\($0)"}])
            .bind(to: entryPicker.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)
 
 */
        
        controller.historyDataOutput.bind(to: historyTableView.rx.items(cellIdentifier: "CombinedCell", cellType: CombinedTableViewCell.self)) { row, model, cell in
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
        
//        Observable.just([HistoryTableInput(date: "today", total: "25")])
        
  
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Ask controller to send data
        controller.send()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
