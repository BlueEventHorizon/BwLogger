//
//  Date+Ext.swift
//  BwCore
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

// MARK: - 文字列 <-> Date

public extension Date {
    // Date → String
    func string(dateFormatType: FormatterType = .std, timeZone: TimeZone = .current) -> String {
        string(dateFormat: dateFormatType.rawValue, timeZone: timeZone)
    }

    // Date → String
    func string(dateFormat: String, timeZone: TimeZone) -> String {
        let formatter = DateFormatter.withTimeZone(timeZone)
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }

    // String → Date
    init?(dateString: String, dateFormatType: FormatterType = .std) {
        self.init(dateString: dateString, dateFormat: dateFormatType.rawValue)
    }

    // String → Date
    init?(dateString: String, dateFormat: String) {
        let formatter = DateFormatter.standard
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: dateString) else { return nil }
        self = date
    }
}

public extension Date {
    func stringTokyoTimeZone(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = dateFormat

        return formatter.string(from: self)
    }
}
