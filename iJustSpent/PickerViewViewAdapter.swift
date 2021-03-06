//  Copyright © 2019 David New. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

//From https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Examples/UIPickerViewExample/CustomPickerViewAdapterExampleViewController.swift
//Needed for customisation of picker view

class PickerViewViewAdapter
    : NSObject
    , UIPickerViewDataSource
    , UIPickerViewDelegate
    , RxPickerViewDataSourceType
, SectionedViewDataSourceType {
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = []
    
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        if pickerView.tag == 1 || pickerView.tag == 5 {
            //This tag is a currency symbol or colon
            label.backgroundColor = UIColor.black
            label.textColor = UIColor.white
        }
        //Else it is a number
        else if ["1","2","3","4","5","6","7","8","9"] .contains(label.text) {
            label.backgroundColor = UIColor.darkGray
            label.textColor = UIColor.white
        }
        //Zeros a different colour
        else {
            label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            label.textColor = UIColor.black
        }
        label.font = UIFont.systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }
  
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
            }.on(observedEvent)
    }
}


