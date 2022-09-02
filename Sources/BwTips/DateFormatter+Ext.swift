//
//  DateFormatter+Ext.swift
//  BwCore
//
//  Created by k2moons on 2021/03/25.
//  Copyright © 2021 k2moons. All rights reserved.
//

import Foundation

public enum FormatterType: String {
    case detail = "yyyy/MM/dd HH:mm:ss.SSS z"
    case full = "yyyy-MM-dd'T'HH:mm:ssZ"
    case std = "yyyy-MM-dd HH:mm:ss"
    case birthday = "yyyy-MM-dd"
}

// MARK: - DateFormatter

public extension DateFormatter {
    // 現在タイムゾーンの標準フォーマッタ
    static let standard: DateFormatter = withTimeZone(.current)

    static func withTimeZone(_ timeZone: TimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }
}
