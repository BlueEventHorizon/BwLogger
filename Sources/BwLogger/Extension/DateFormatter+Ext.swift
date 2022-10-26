//
//  DateFormatter+Ext.swift
//  BwCore
//
//  Created by k2moons on 2021/03/25.
//  Copyright © 2021 k2moons. All rights reserved.
//

#if LOGGER_PRIVATE_EXTENSION_ENABLED

import Foundation

// https://developer.apple.com/documentation/foundation/dateformatter

enum FormatStringType: String {
    case detail = "yyyy/MM/dd HH:mm:ss.SSS z"
    case full = "yyyy-MM-dd'T'HH:mm:ssZ"
    case std = "yyyy-MM-dd HH:mm:ss"
    case birthday = "yyyy-MM-dd"
}

enum FormatTemplateType: String {
    case dayMonth = "MMMMd"
}

extension DateFormatter {
    // MARK: - User-Visible Representations

    static func visibleFormatter(style: DateFormatter.Style, locale: Locale = Locale.current) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = locale
        formatter.dateStyle = style
        formatter.timeStyle = style
        return formatter
    }

    static func visibleFormatter(template: String, locale: Locale = Locale.current) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate(template)
        return formatter
    }

    static func visibleFormatter(locale: Locale = Locale.current, templateType: FormatTemplateType) -> DateFormatter {
        visibleFormatter(template: templateType.rawValue, locale: locale)
    }

    // MARK: - Fixed Format Date Representations

    static func fixedFormatter(dateFormat: String, timeZone: TimeZone? = .current) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = dateFormat
        return formatter
    }

    static func fixedFormatter(formatStringType: FormatStringType, timeZone: TimeZone? = .current) -> DateFormatter {
        fixedFormatter(dateFormat: formatStringType.rawValue, timeZone: timeZone)
    }

    /// 現在タイムゾーンの標準フォーマッタ
    static let standard: DateFormatter = fixedFormatter(dateFormat: "", timeZone: .current)
}

#endif
