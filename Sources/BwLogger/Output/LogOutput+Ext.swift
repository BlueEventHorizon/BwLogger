//
//  LogOutput+Ext.swift
//  BwLogger
//
//  Created by k2moons on 2022/10/26.
//

import Foundation

public extension LogOutput {
    // stringが空でなければstringの前にspacerを追加する
    func addSeparater(_ string: String, prefix: String = " ") -> String {
        guard string.isNotEmpty else { return "" }

        return "\(prefix)\(string)"
    }

    // swiftlint:disable switch_case_on_newline
    func prefix(with info: LogInformation) -> String {
        if let prefix = info.prefix {
            return prefix
        }

        switch info.level {
            case .log: return ""
            case .debug: return "#DEBG"
            case .info: return "#INFO"
            case .warning: return "#WARN"
            case .error: return "#🔥"
            case .fault: return "#🔥🔥"
        }
    }

    func generateMessage(with info: LogInformation) -> String {
        let prefix = prefix(with: info)
        return info.level == .info ?
            "\(prefix)\(addSeparater(info.message)) [\(info.objectName)]" :
            "\(prefix) [\(info.timestamp())]\(addSeparater(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}
