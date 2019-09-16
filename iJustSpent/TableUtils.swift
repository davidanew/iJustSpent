//  Copyright © 2019 David New. All rights reserved.

import Foundation
import os.log

//Static functions to prepare table data
class TableUtils {
    struct DayHistoryTableInput {
        var date : String
        var total : String
    }
    
    private static func dateToText (_ date: Date) -> String {
        let weekDay = DateFormatter().shortWeekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
        let month = DateFormatter().shortMonthSymbols[Calendar.current.component(.month, from: date)-1]
        let dayOfMonth = Calendar.current.component(.day, from: date)
        return ("\(weekDay) \(dayOfMonth) \(month)")
    }
    //Calculate daily spend from the list of individual spends from spendStore
    static func getTotalByDayForTableView (spendDateAndValueArray : [SpendDateAndValue]) -> [DayHistoryTableInput] {
        struct UnitsAndSubunits {
            var units : SpendIntType
            var subUnits : SpendIntType
        }
        //Dictionary that will hold the above struct
        var dayDictionary : Dictionary<Date, UnitsAndSubunits> = [:]
        //For each spend add this to a dictionary entry corresponding to that day
        spendDateAndValueArray.forEach { (spendDateAndValue) in
            guard let thisDate = spendDateAndValue.date else {
                os_log("date is nil")
                return
            }
            let thisStartOfDay = Calendar.current.startOfDay(for: thisDate)
            //This day does not exist in dictionary
            if dayDictionary[thisStartOfDay] == nil {
                dayDictionary[thisStartOfDay] = UnitsAndSubunits(units: spendDateAndValue.units, subUnits: spendDateAndValue.subUnits)
            }
            //This day does exist, add the spend to this day
            else {
                let subUnitsSum = (dayDictionary[thisStartOfDay]?.subUnits ?? 999) + spendDateAndValue.subUnits
                let subUnitsMod = subUnitsSum % 100
                let subUnitsCarry = SpendIntType((subUnitsSum-subUnitsMod)/100)
                let unitsSum = (dayDictionary[thisStartOfDay]?.units ?? 999) + spendDateAndValue.units + subUnitsCarry
                dayDictionary[thisStartOfDay]?.units = unitsSum
                dayDictionary[thisStartOfDay]?.subUnits = subUnitsMod
            }
        }
        //This is the data structure to be sent back to the tableview
        var totalByDay : [DayHistoryTableInput] = []
        let sortedKeysAndValues = dayDictionary.sorted(by: { $0.0 > $1.0  })
        //Process dictionary items and add to totalByDay
        sortedKeysAndValues.forEach { (key: Date, value: UnitsAndSubunits) in
            var dateText : String
            if Calendar.current.startOfDay(for: key) == Calendar.current.startOfDay(for: Date()) {
                dateText = "Today"
            }
            else if Calendar.current.startOfDay(for: key) == Calendar.current.startOfDay(for: Date().addingTimeInterval(-1*60*60*24)) {
                dateText = "Yesterday"
            }
            else {
                dateText = dateToText(key)
            }
            let defaults = UserDefaults.standard
            let currencySymbol = defaults.object(forKey:"currencySymbol") as? String ?? "$"
            totalByDay.append(DayHistoryTableInput(date: dateText, total: "\(currencySymbol)\(value.units):\(String(format: "%02d", value.subUnits ))"  ))
        }
        return totalByDay
    }
}
