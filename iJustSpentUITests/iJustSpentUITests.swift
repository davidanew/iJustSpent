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
    }
    
    let currencyIdentifier : String = "£"
    
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
    
    func clearAllData(){
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        while table.cells.count > 0 {
            app.buttons["Undo"].tap()
        }
    }
    
    func clearLatest(){
        let app = XCUIApplication()
        app.buttons["Undo"].tap()
    }
    
    func testAutoAddOneItem(){
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        clearAllData()
        addDataValue(inputTuple: (5,4,3,2,1))
        let topCell = table.cells.element(matching: .cell, identifier: "cell_0") //as? CombinedTableViewCell
        XCTAssertTrue(topCell.staticTexts["Today"].exists)
        XCTAssertTrue(topCell.staticTexts["$543:21"].exists)
        clearAllData()
    }
    
    func testManualJustWait(){
        Thread.sleep(forTimeInterval: 5.0)
    }
    
    func testAutoUnitTestAddedItems(){
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
        XCTAssertTrue(cell0.staticTexts["Today"].exists); XCTAssertTrue(cell0.staticTexts["\(currencyIdentifier)5:95"].exists)
        XCTAssertTrue(cell1.staticTexts["Yesterday"].exists); XCTAssertTrue(cell1.staticTexts["\(currencyIdentifier)10:01"].exists)
        XCTAssertTrue(cell2.staticTexts["Sat 14 Sep"].exists); XCTAssertTrue(cell2.staticTexts["\(currencyIdentifier)999:23"].exists)
        XCTAssertTrue(cell3.staticTexts["Sat 25 May"].exists); XCTAssertTrue(cell3.staticTexts["\(currencyIdentifier)23:92"].exists)
        XCTAssertTrue(cell4.staticTexts["Thu 16 May"].exists); XCTAssertTrue(cell4.staticTexts["\(currencyIdentifier)93:39"].exists)
        XCTAssertTrue(cell5.staticTexts["Sat 30 Mar"].exists); XCTAssertTrue(cell5.staticTexts["\(currencyIdentifier)56:19"].exists)
        XCTAssertTrue(cell6.staticTexts["Fri 8 Feb"].exists); XCTAssertTrue(cell6.staticTexts["\(currencyIdentifier)132:99"].exists)
        XCTAssertTrue(cell7.staticTexts["Tue 1 Jan"].exists); XCTAssertTrue(cell7.staticTexts["\(currencyIdentifier)163:01"].exists)
        XCTAssertTrue(cell8.staticTexts["Fri 3 Feb"].exists); XCTAssertTrue(cell8.staticTexts["\(currencyIdentifier)2:20"].exists)
        XCTAssertTrue(cell9.staticTexts["Sat 1 Oct"].exists); XCTAssertTrue(cell9.staticTexts["\(currencyIdentifier)0:03"].exists)
        XCTAssertTrue(cell10.staticTexts["Sun 8 Dec"].exists); XCTAssertTrue(cell10.staticTexts["\(currencyIdentifier)25:92"].exists)
        XCTAssertTrue(cell11.staticTexts["Wed 10 Mar"].exists); XCTAssertTrue(cell11.staticTexts["\(currencyIdentifier)123:64"].exists)
    }
    
    func testAddMultipleItems(){
        clearAllData()
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        let cell0 = table.cells.element(matching: .cell, identifier: "cell_0")
        for _ in 1...100 {
            addDataValue(inputTuple: (0,0,0,0,1))
        }
        addDataValue(inputTuple: (0,0,1,0,0))
        //the 101th value should be removed
        XCTAssertTrue(cell0.staticTexts["Today"].exists); XCTAssertTrue(cell0.staticTexts["\(currencyIdentifier)1:99"].exists)
        Thread.sleep(forTimeInterval: 1.0)
    }
    
    //production test
    func testAuto(){
        //unit test add funtion needs to be run first
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: "tableView")
        testAutoUnitTestAddedItems()
        clearLatest()
        let cell0 = table.cells.element(matching: .cell, identifier: "cell_0")
        XCTAssertTrue(cell0.staticTexts["Yesterday"].exists); XCTAssertTrue(cell0.staticTexts["\(currencyIdentifier)10:01"].exists)
        addDataValue(inputTuple: (0,0,5,9,5))
        testAutoUnitTestAddedItems()
        testAddMultipleItems()
    }
 }
