//
//  Date+Additions.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/15/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

extension Date {
    
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
    
    func fullTimeNoneFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
    
    func shortTimeNoneFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
    
}
