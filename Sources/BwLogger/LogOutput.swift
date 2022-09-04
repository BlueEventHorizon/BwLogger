//
//  LogOutput.swift
//
//
//  Created by k2moons on 2021/08/06.
//

import BwTips
import Foundation

public protocol LogOutput {
    func log(_ information: LogInformation)

    func addSeparater(_ string: String, prefix: String) -> String
    func prefix(with info: LogInformation) -> String
    func generateMessage(with info: LogInformation) -> String
}

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
            case .debug: return "🛠DEBUG"
            case .info: return "🔵INFOM"
            case .warning: return "⚠️WARNG"
            case .error: return "🔥ERROR"
            case .fault: return "🔥🔥🔥🔥"
        }
    }

    func generateMessage(with info: LogInformation) -> String {
        let prefix = prefix(with: info)
        return info.level == .info ?
            "\(prefix)\(addSeparater(info.message)) [\(info.objectName)]" :
            "\(prefix) [\(info.timestamp())]\(addSeparater(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}
