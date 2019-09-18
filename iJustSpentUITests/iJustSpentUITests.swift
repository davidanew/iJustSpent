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
        let topCell = table.cells.element(matching: .cell, identifier: "cell_0") //as? CombinedTableViewCell
        XCTAssertTrue(topCell.staticTexts["Today"].exists); XCTAssertTrue(topCell.staticTexts["$5:95"].exists)
        XCTAssertTrue(topCell.staticTexts["Yesterday"].exists); XCTAssertTrue(topCell.staticTexts["$10:01"].exists)
        XCTAssertTrue(topCell.staticTexts["Sat 1 Oct"].exists); XCTAssertTrue(topCell.staticTexts["$0:02"].exists)
        XCTAssertTrue(topCell.staticTexts["Fri 3 Feb"].exists); XCTAssertTrue(topCell.staticTexts["$1:10"].exists)
        XCTAssertTrue(topCell.staticTexts["Sun 8 Dec"].exists); XCTAssertTrue(topCell.staticTexts["$25:92"].exists)
        XCTAssertTrue(topCell.staticTexts["Wed 10 Mar"].exists); XCTAssertTrue(topCell.staticTexts["$123:64"].exists)
        XCTAssertTrue(topCell.staticTexts["Thu 16 May"].exists); XCTAssertTrue(topCell.staticTexts["$93:39"].exists)
        XCTAssertTrue(topCell.staticTexts["Sat 21 Sep"].exists); XCTAssertTrue(topCell.staticTexts["$999:23"].exists)
        XCTAssertTrue(topCell.staticTexts["Sat 25 May"].exists); XCTAssertTrue(topCell.staticTexts["$23:92"].exists)
        XCTAssertTrue(topCell.staticTexts["Sat 30 Mar"].exists); XCTAssertTrue(topCell.staticTexts["$56:19"].exists)
        XCTAssertTrue(topCell.staticTexts["Fri 8 Feb"].exists); XCTAssertTrue(topCell.staticTexts["$132:99"].exists)
        XCTAssertTrue(topCell.staticTexts["Tue 1 Jan"].exists); XCTAssertTrue(topCell.staticTexts["$163:01"].exists)
    }
    
    //Sat 1 Oct $0:02
    //Fri 3 Feb $1:10
    //Sun 8 Dec $25:92
    //Wed 10 Mar $123:64
    //Thu 16 May $93:39
    //Sat 21 Sept $999:23
    //Sat 25 May $23:92
    //Sat 30 Mar $56:19
    //Fri 8 Feb $132:99
    //Tue 1 Jan $163:01

    
    
    //Saturday, 8 October 2016
    //Saturday, 8 October 2016 $0:02
    //Wednesday, 8 February 2017
    //Wednesday, 8 February 2017 $1:10
    //Sunday, 8 December 2013 $25:92
    //Monday, 8 March 2010 $123:64
    //Wednesday, 8 May 2019 $93:39
    //Sunday, 8 September 2019 $999:23
    //Wednesday, 8 May 2019 $23:92
    //Friday, 8 March 2019 $56:19
    //Friday, 8 February 2019 $132:99
    //Tuesday, 8 January 2019 $163:01
    
}
