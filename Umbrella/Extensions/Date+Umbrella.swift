//
//  Date+Umbrella.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/20/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

extension Date{
    
    /// Converts the date to start of the day
    ///
    /// - Returns: Date at 12:00:00AM.
    func beginingOfTheDay() -> Date{
        let gregorian = Calendar(identifier: .gregorian)
        var beginingOfTheDayComponents = gregorian.dateComponents([.year, .month, .day], from: self)
        beginingOfTheDayComponents.hour = 0
        beginingOfTheDayComponents.minute = 0
        beginingOfTheDayComponents.second = 0
        return gregorian.date(from: beginingOfTheDayComponents)!
    }
    
    /// Replaces the date component with a phrase—such as “today” or “tomorrow”
    ///
    /// - Returns: Returns relative date.
    func toRelativeDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        dateFormater.locale = Locale(identifier: "en_US")
        dateFormater.doesRelativeDateFormatting = true
        return dateFormater.string(from: self)
    }
    
    /// Returns the time of the date component
    ///
    /// - Returns: Returns time in Apple's short fromat.
    func toShortTime() -> String {
        let timeFormater = DateFormatter()
        timeFormater.timeStyle = .short
        timeFormater.dateStyle = .none
        timeFormater.locale = Locale(identifier: "en_US")
        return timeFormater.string(from: self)
    }
    
}
