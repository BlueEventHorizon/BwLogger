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
    public func prefixIfNotEmpty(string: String, prefix: String = " ") -> String {
        guard string.isNotEmpty else { return "" }

        return "\(prefix)\(string)"
    }

    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log:
                return ""

            case .debug:
                return "🛠"

            case .info:
                return "🔵"

            case .warning:
                return "⚠️"

            case .error:
                return "🚫"

            case .fault:
                return "🔥"
        }
    }

    public func generateMessage(with information: LogInformation) -> String {
        let separator: String = information.message.isEmpty ? "" : " --"

        let prefix: String
        if let prefixtmp = information.prefix {
            // information内にprefixがあれば優先して使用する
            prefix = prefixtmp
        } else {
            prefix = self.prefix(for: information.level)
        }

        return information.level == .info ?
            "\(prefix)\(prefixIfNotEmpty(string: information.message))\(separator) \(information.methodName)" :
            "\(prefix) [\(information.timestamp())] [\(information.threadName)]\(prefixIfNotEmpty(string: information.message))\(separator) \(information.methodName) \(information.fileName):\(information.line))"
    }
}

#if LOGGER_PRIVATE_EXTENSION_ENABLED
    // swiftlint:disable strict_fileprivate

    extension String {
        fileprivate var isNotEmpty: Bool {
            !self.isEmpty
        }
    }

    // swiftlint:enable strict_fileprivate
#endif
