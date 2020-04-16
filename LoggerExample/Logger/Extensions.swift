//
//  Extensions.swift
//  Logger
//
//  Created by k_terada on 2020/04/16.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

extension Date {
    // Date → String
    public func string(dateFormat: String) -> String {
        let formatter = DateFormatter.standard
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    // 現在タイムゾーンの標準フォーマッタ
    public static let standard: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
}
