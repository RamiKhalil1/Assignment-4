import Foundation
import SwiftUI

let months = Array(1...12)
let years = Array(1900...2100)
let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

var yearFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    return formatter
}

func updateDateForNewMonthOrYear(newMonth: Int, newYear: Int, date: Date) -> Date {
    let calendar = Calendar.current
    let newMonthFirstDate = calendar.date(from: DateComponents(year: newYear, month: newMonth, day: 1))
    let numberOfDaysInNewMonth = newMonthFirstDate?.numberOfDaysInMonth
    
    var newDay = calendar.component(.day, from: date)
    if newDay > numberOfDaysInNewMonth! {
       newDay = numberOfDaysInNewMonth!
    }
    return Calendar.current.date(from: DateComponents(year: newYear, month: newMonth, day: newDay))!
}

func getEntriesDate(moodEntries: FetchedResults<Mood>) -> [Date] {
    var entriesDates: [Date] = []
    for mood in moodEntries {
        if let date = mood.date, !entriesDates.contains(date.startOfDay) {
            entriesDates.append(date.startOfDay)
        }
    }
    return entriesDates
}
