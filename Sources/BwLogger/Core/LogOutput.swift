//
//  LogOutput.swift
//
//
//  Created by Katsuhiko Terada on 2021/08/06.
//

import Foundation

public protocol LogOutput {
    func log(_ information: LogInformation)
    func prefix(for level: Logger.Level) -> String
    func generateMessage(with information: LogInformation) -> String
}

extension LogOutput {
    // stringが空でなければstringの前にspacerを追加する
    public func addBlankBefore(_ string: String, prefix: String = " ") -> String {
        guard string.isNotEmpty else { return "" }

        return "\(prefix)\(string)"
    }

    // swiftlint:disable switch_case_on_newline
    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log:      return ""
            case .debug:    return "🛠DEBUG"
            case .info:     return "🔵INFOM"
            case .warning:  return "⚠️WARNG"
            case .error:    return "🔥ERROR"
            case .fault:    return "🔥🔥🔥🔥"
        }
    }

    public func generateMessage(with info: LogInformation) -> String {
        let prefix: String
        if let prefixtmp = info.prefix {
            // information内にprefixがあれば優先して使用する
            prefix = prefixtmp
        } else {
            prefix = self.prefix(for: info.level)
        }

        return info.level == .info ?
            "\(prefix)\(addBlankBefore(info.message)) [\(info.objectName)]" :
            "\(prefix) [\(info.timestamp())]\(addBlankBefore(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}
