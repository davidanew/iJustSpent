//
//  Copyright © 2019 David New. All rights reserved.

import XCTest
import Foundation
import RxSwift
import RxCocoa
import os.log
import CoreData

@testable import iJustSpent

class iJustSpentUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testManualSetOnePicker(){
        let app = XCUIApplication()
        let poundsHundredsPicker = app.pickers["poundsHundreds"]
        poundsHundredsPicker.pickerWheels.element.adjust(toPickerWheelValue: "1")
        Thread.sleep(forTimeInterval: 5.0)
    }
    
    func testManualSetAllPickers(){
        let app = XCUIApplication()
        let poundsHundredsPicker = app.pickers["poundsHundreds"]
        let poundsTensPicker = app.pickers["poundsTens"]
        let poundsUnitsPicker = app.pickers["poundsUnits"]
        let penceTensPicker = app.pickers["penceTens"]
        let penceUnitsPicker = app.pickers["penceUnits"]

        poundsHundredsPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        poundsTensPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        poundsUnitsPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        penceTensPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        penceUnitsPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")

        Thread.sleep(forTimeInterval: 5.0)
    }
    
    func testManualAddValue(){
        let app = XCUIApplication()
        let poundsHundredsPicker = app.pickers["poundsHundreds"]
        let poundsTensPicker = app.pickers["poundsTens"]
        let poundsUnitsPicker = app.pickers["poundsUnits"]
        let penceTensPicker = app.pickers["penceTens"]
        let penceUnitsPicker = app.pickers["penceUnits"]
        //let addButton = app.buttons["addButton"]
        
        poundsHundredsPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        poundsTensPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        poundsUnitsPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        penceTensPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        penceUnitsPicker.pickerWheels.element.adjust(toPickerWheelValue: "9")
        app.buttons["Add Spend"].tap()

        Thread.sleep(forTimeInterval: 5.0)
    }
    
    
    func addDataValue(inputTuple : (Int,Int,Int,Int,Int)){
        let app = XCUIApplication()
        let poundsHundredsPicker = app.pickers["poundsHundreds"]
        let poundsTensPicker = app.pickers["poundsTens"]
        let poundsUnitsPicker = app.pickers["poundsUnits"]
        let penceTensPicker = app.pickers["penceTens"]
        let penceUnitsPicker = app.pickers["penceUnits"]
        poundsHundredsPicker.pickerWheels.element.adjust(toPickerWheelValue: String(inputTuple.0))
        poundsTensPicker.pickerWheels.element.adjust(toPickerWheelValue: String(inputTuple.1))
        poundsUnitsPicker.pickerWheels.element.adjust(toPickerWheelValue: String(inputTuple.2))
        penceTensPicker.pickerWheels.element.adjust(toPickerWheelValue: String(inputTuple.3))
        penceUnitsPicker.pickerWheels.element.adjust(toPickerWheelValue: String(inputTuple.4))
        app.buttons["Add Spend"].tap()

    }
    
    
    func clearData(){
        
        
        
        
        //this will need to see if there is data in the table view, if so then delete
        //repeat above until empty
        let app = XCUIApplication()
        
        //let poundsHundredsPicker = app.pickers["poundsHundreds"]
        //poundsHundredsPicker.pickerWheels.element.adjust(toPickerWheelValue: "1")
        //app.buttons["Add Spend"].tap()
        //poundsHundredsPicker.pickerWheels.element.adjust(toPickerWheelValue: "1")
        //app.buttons["Add Spend"].tap()
        
        
        //Thread.sleep(forTimeInterval: 1.0)
        
        let myTable = app.tables.matching(identifier: "tableView")
        //let myTable = app.table["table identifier"]
        
        print(myTable.cells.count)

        while myTable.cells.count > 0 {
            app.buttons["Undo"].tap()
            

        }
        print(myTable.cells.count)
        
        
        
        //Thread.sleep(forTimeInterval: 5.0)

        //let cell = myTable.cells.element(matching: .cell, identifier: "myCell_0")
    }
    
    func testManualAddDataAndClear(){
        addDataValue(inputTuple: (1,2,3,4,5))
        Thread.sleep(forTimeInterval: 1.0)
        clearData()
        Thread.sleep(forTimeInterval: 5.0)

    }
    
    
    
    



}

//func setTimePicker(time: TimePickerInput) {
//    let app = XCUIApplication()
//    let timeHours = app.pickers["timeHours"]
//    let timeMinutes = app.pickers["timeMinutes"]
//    let timeSeconds = app.pickers["timeSeconds"]
//    timeHours.pickerWheels.element.adjust(toPickerWheelValue: String(time.hours))
//    timeMinutes.pickerWheels.element.adjust(toPickerWheelValue: String(format: "%02d", time.minutes))
//    timeSeconds.pickerWheels.element.adjust(toPickerWheelValue: String(format: "%02d", time.seconds))
//}

//func testAuto() {
//    testInitAndError()
//    testHelp() // not auto
//    testPopulateFields() //not auto
//    testCase()
//    testExtremes()
//}
