//
//  PublishedLogger.swift
//  LoggerApp
//
//  Created by Katsuhiko Terada on 2021/07/10.
//

import BwLogger
import Combine
import Foundation

// swiftlint:disable:next prefixed_toplevel_constant
let log = Logger([PublishedLogger.shared])

class PublishedLogger: ObservableObject, LogOutput {
    static let shared = PublishedLogger()

    var logMessage = PassthroughSubject<String, Never>()

    func log(_ information: LogInformation) {
        let message = generateMessage(with: information)

        logMessage.send(message)
    }
}

extension LogOutput {
    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log:
                return ""

            case .debug:
                return "✴️"

            case .info:
                return "✳️"

            case .warning:
                return "⚠️"

            case .error:
                return "🔥"

            case .fault:
                return "🔴"
        }
    }
}
