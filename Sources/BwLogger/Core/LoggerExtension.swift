//
//  LoggerExtension.swift
//  BwTools
//
//  Created by k2moons on 2021/12/01.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

// swiftlint:disable strict_fileprivate

extension String {
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

extension Date {
    // Date → String
    func string(dateFormat: String) -> String {
        let formatter = DateFormatter.standard
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    // 現在タイムゾーンの標準フォーマッタ
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
}

// swiftlint:enable strict_fileprivate
