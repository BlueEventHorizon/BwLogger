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
    func getStandardMessage(with information: LogInformation) -> String
}

extension LogOutput {
    // stringが空でなければstringの前にspacerを追加する
    public func addSpacer(_ spacer: String, before string: String) -> String {
        guard string.isNotEmpty else { return "" }

        return "\(spacer)\(string)"
    }

    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log: return ""
            case .debug: return "🛠"
            case .info: return "🔵"
            case .warning: return "⚠️"
            case .error: return "🚫"
            case .fault: return "🔥"
        }
    }

    public func getStandardMessage(with information: LogInformation) -> String {
        let separator: String = information.message.isEmpty ? "" : " --"

        let prefix: String
        if let _prefix = information.prefix {
            // information内にprefixがあれば優先して使用する
            prefix = _prefix
        } else {
            prefix = self.prefix(for: information.level)
        }

        return information.level == .info ?
            "\(prefix)\(addSpacer(" ", before: information.message))\(separator) \(information.methodName)" :
            "\(prefix) [\(information.timestamp())] [\(information.threadName)]\(addSpacer(" ", before: information.message))\(separator) \(information.methodName) \(information.fileName):\(information.line))"
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
