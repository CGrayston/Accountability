//
//  Date+Additions.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/15/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

extension Date {

    var utc: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone(identifier: "UTC")!
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 2
        guard let monday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return monday
    }

    var endOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 2
        guard let monday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: monday)
    }
    
    func dateFormatter(_ format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        
        return dateFormatter.string(from: self)
    }
    
    func standardFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
        
        return dateFormatter.string(from: self)
    }
        
    func fullTimeShortFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self)
    }
    
    func shortTimeNoneFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
    
    func isDateToday() -> Bool {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.isDateInToday(self)
    }
}
