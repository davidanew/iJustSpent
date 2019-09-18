//
//  Copyright © 2019 David New. All rights reserved.

import XCTest
import Foundation
import RxSwift
import RxCocoa
import os.log
import CoreData

@testable import iJustSpent
//@testable import iJustSpentTests

class iJustSpentUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        //SpendStoreTests.testExample()
        
    }
    /*
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
    
    */
    
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
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        print(table.cells.count)
        while table.cells.count > 0 {
            app.buttons["Undo"].tap()
        }
        print(table.cells.count)
        //let cell = myTable.cells.element(matching: .cell, identifier: "myCell_0")
    }
    
    /*
    func testManualAddDataAndClear(){
        addDataValue(inputTuple: (1,2,3,4,5))
        Thread.sleep(forTimeInterval: 1.0)
        clearData()
        Thread.sleep(forTimeInterval: 5.0)
    }
    */
    func testAutoAddOneItem(){
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        clearData()
        addDataValue(inputTuple: (5,4,3,2,1))
        let topCell = table.cells.element(matching: .cell, identifier: "cell_0") //as? CombinedTableViewCell
        XCTAssertTrue(topCell.staticTexts["Today"].exists)
        XCTAssertTrue(topCell.staticTexts["$543:21"].exists)
        clearData()
    }
    
    func testJustWait(){
        Thread.sleep(forTimeInterval: 5.0)
    }
    
    func testUnitTestAddedItems(){
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        //TODO: Some loop to get identifiers?
        let cell0 = table.cells.element(matching: .cell, identifier: "cell_0")
        let cell1 = table.cells.element(matching: .cell, identifier: "cell_1")
        let cell2 = table.cells.element(matching: .cell, identifier: "cell_2")
        let cell3 = table.cells.element(matching: .cell, identifier: "cell_3")
        let cell4 = table.cells.element(matching: .cell, identifier: "cell_4")
        let cell5 = table.cells.element(matching: .cell, identifier: "cell_5")
        let cell6 = table.cells.element(matching: .cell, identifier: "cell_6")
        let cell7 = table.cells.element(matching: .cell, identifier: "cell_7")
        let cell8 = table.cells.element(matching: .cell, identifier: "cell_8")
        let cell9 = table.cells.element(matching: .cell, identifier: "cell_9")
        let cell10 = table.cells.element(matching: .cell, identifier: "cell_10")
        let cell11 = table.cells.element(matching: .cell, identifier: "cell_11")

        XCTAssertTrue(cell0.staticTexts["Today"].exists); XCTAssertTrue(cell0.staticTexts["$5:95"].exists)
        XCTAssertTrue(cell1.staticTexts["Yesterday"].exists); XCTAssertTrue(cell1.staticTexts["$10:01"].exists)
        XCTAssertTrue(cell2.staticTexts["Sat 14 Sep"].exists); XCTAssertTrue(cell2.staticTexts["$999:23"].exists)
        XCTAssertTrue(cell3.staticTexts["Sat 25 May"].exists); XCTAssertTrue(cell3.staticTexts["$23:92"].exists)
        XCTAssertTrue(cell4.staticTexts["Thu 16 May"].exists); XCTAssertTrue(cell4.staticTexts["$93:39"].exists)
        XCTAssertTrue(cell5.staticTexts["Sat 30 Mar"].exists); XCTAssertTrue(cell5.staticTexts["$56:19"].exists)
        XCTAssertTrue(cell6.staticTexts["Fri 8 Feb"].exists); XCTAssertTrue(cell6.staticTexts["$132:99"].exists)
        XCTAssertTrue(cell7.staticTexts["Tue 1 Jan"].exists); XCTAssertTrue(cell7.staticTexts["$163:01"].exists)
        XCTAssertTrue(cell8.staticTexts["Fri 3 Feb"].exists); XCTAssertTrue(cell8.staticTexts["$2:20"].exists)
        XCTAssertTrue(cell9.staticTexts["Sat 1 Oct"].exists); XCTAssertTrue(cell9.staticTexts["$0:03"].exists)
        XCTAssertTrue(cell10.staticTexts["Sun 8 Dec"].exists); XCTAssertTrue(cell10.staticTexts["$25:92"].exists)
        XCTAssertTrue(cell11.staticTexts["Wed 10 Mar"].exists); XCTAssertTrue(cell11.staticTexts["$123:64"].exists)
    }
    
    //Sat 14 Sept 2019 $999:23
    //Sat 25 May 2019 $23:92

    //Thu 16 May 2019 $93:39
    //Sat 30 Mar 2019  $56:19
    //Fri 8 Feb 2019 $132:99
    //Tue 1 Jan 2019 $163:01
    //Fri 3 Feb 2017 $2:20
    //Sat 1 Oct 2016 $0:02
    //Sun 8 Dec 2013 $25:92
    //Wed 10 Mar 2010 $123:64


    
    
}
