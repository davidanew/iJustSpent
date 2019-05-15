//  Copyright © 2019 David New. All rights reserved.

import Foundation
import os.log


class TableUtils {
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
            if dayDictionary[thisStartOfDay] == nil {
                dayDictionary[thisStartOfDay] = UnitsAndSubunits(units: spendDateAndValue.units, subUnits: spendDateAndValue.subUnits)
            }
            else {
                let subUnitsSum = (dayDictionary[thisStartOfDay]?.subUnits ?? 999) + spendDateAndValue.subUnits
                let subUnitsMod = subUnitsSum % 100
                let subUnitsCarry = SpendIntType((subUnitsSum-subUnitsMod)/100)
                let unitsSum = (dayDictionary[thisStartOfDay]?.units ?? 999) + spendDateAndValue.units + subUnitsCarry
                dayDictionary[thisStartOfDay]?.units = unitsSum
                dayDictionary[thisStartOfDay]?.subUnits = subUnitsMod
            }
        }
        var totalByDay : [DayHistoryTableInput] = []
        let sortedKeysAndValues = dayDictionary.sorted(by: { $0.0 > $1.0  })
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
            //TODO: sort out symbol
            totalByDay.append(DayHistoryTableInput(date: dateText, total: "£\(value.units):\(String(format: "%02d", value.subUnits ))"  ))
        }
        return totalByDay
    }
}
